import Text "mo:base/Text";
import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Nat8 "mo:base/Nat8";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Blob "mo:base/Blob";
import Buffer "mo:base/Buffer";
import Result "mo:base/Result";
import Char "mo:base/Char";

module {
  public type Encoding = {
    #BECH32; #BECH32M;
  };

  // A decoded result contains Encoding type, human-readable part (HRP), and Data.
  public type DecodeResult = (Encoding, Text, [Nat8]);

  let CHAR_a : Nat8 = 0x61;
  let CHAR_A : Nat8 = 0x41;
  let CHAR_z : Nat8 = 0x71;
  let CHAR_Z : Nat8 = 0x5a;
  let CHAR_1 : Nat8 = 0x31;
  // Code for '!'.
  let CHARS_LOWLIMIT : Nat8 = 0x21;
  // Code for '~'.
  let CHARS_HIGHLIMIT : Nat8 = 0x7e;

  let charset : [Char] = [
    'q', 'p', 'z', 'r', 'y', '9', 'x', '8', 'g', 'f', '2', 't', 'v', 'd', 'w',
    '0', 's', '3', 'j', 'n', '5', '4', 'k', 'h', 'c', 'e', '6', 'm', 'u', 'a',
    '7', 'l'
  ];

  // Mapping from ASCII to indices in charset for characters that exist in
  // charset. 255 is treated as a non-valid index.
  let reverseCharset : [Nat8] = [
    255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 15, 255, 10, 17, 21, 20, 26, 30,  7,  5, 255, 255, 255, 255,
    255, 255, 255, 29, 255, 24, 13, 25,  9,  8, 23, 255, 18, 22, 31, 27, 19,
    255, 1,  0,  3, 16, 11, 28, 12, 14,  6,  4,  2, 255, 255, 255, 255, 255,
    255, 29, 255, 24, 13, 25,  9,  8, 23, 255, 18, 22, 31, 27, 19, 255, 1,  0,
    3, 16, 11, 28, 12, 14,  6,  4,  2, 255, 255, 255, 255, 255
  ];

  // Encode input in Bech32 or a Bech32m.
  public func encode(hrp : Text, values : [Nat8], encoding : Encoding) : Text {
    // Ensure HRP is lowercase.
    let encodedHrp : [Nat8] = Blob.toArray(Text.encodeUtf8(hrp));
    for (val in encodedHrp.vals()) {
      assert(val < CHAR_A or val > CHAR_Z);
    };

    let checksum : [Nat8] = createChecksum(encodedHrp, values, encoding);

    // hrp | '1' | values | checksum.
    let totalSize = hrp.size() + 1 + values.size() + checksum.size();
    let output : Buffer.Buffer<Char> = Buffer.Buffer<Char>(totalSize);

    for (val in Text.toIter(hrp)) {
      output.add(val)
    };

    output.add('1');

    for (val in values.vals()) {
      output.add(charset[Nat8.toNat(val)]);
    };
    for (val in checksum.vals()) {
      output.add(charset[Nat8.toNat(val)]);
    };

    return Text.fromIter(output.vals());
  };

  // Decode given text as Bech32 or Bech32m.
  public func decode(input : Text) : Result.Result<DecodeResult, Text> {
    // Locate the '1' separator.
    var separatorIndex : Nat = 0;
    var lowercase : Bool = false;
    var uppercase : Bool = false;
    let inputData : [Nat8] = Blob.toArray(Text.encodeUtf8(input));

    for (i in Iter.range(0, inputData.size() - 1)) {
      let c : Nat8 = inputData[i];

      if (c == CHAR_1) {
        separatorIndex := i;
      } else if (isLowercase(c)) {
        lowercase := true;
      } else if (isUppercase(c)) {
        uppercase := true;
      };

      if (not isInRange(c)) {
        return #err("Found unexpected character: " # toText(c));
      };

    };

    if (lowercase == uppercase) {
      return #err ("Inconsistent character casing in HRP.");
    };

    // Ensure length is within bounds.
    if (input.size() > 90 or separatorIndex == 0 or
      separatorIndex + 7 > input.size()) {
      return #err ("Bad separator position: " # (Nat.toText(separatorIndex)));
    };

    // Split into HRP and data.
    let hrpBuffer : Buffer.Buffer<Nat8> = Buffer.Buffer<Nat8>(separatorIndex);
    let valuesBuffer : Buffer.Buffer<Nat8> = Buffer.Buffer<Nat8>(
      input.size() - 1 - separatorIndex);

    for (i in Iter.range(0, separatorIndex - 1)) {
      hrpBuffer.add(toLower(inputData[i]));
    };

    for (i in Iter.range(separatorIndex + 1, inputData.size() - 1)) {
      let c : Nat8 = inputData[i];
      let mappedVal : Nat8 = reverseCharset[Nat8.toNat(c)];

      if (mappedVal == 255) {
        return #err ("Invalid character found: " # toText(c));
      };
      valuesBuffer.add(mappedVal);
    };
    let values : [Nat8] = valuesBuffer.toArray();
    let hrp : [Nat8] = hrpBuffer.toArray();

    return switch (verifyChecksum(hrp, values),
      Text.decodeUtf8(Blob.fromArray(hrp))) {
        case (#err (msg), _) {
          #err (msg)
        };
        case (#ok (encodingType), ?hrp) {
          // Remove checksum from data.
          for (i in Iter.range(0, 5)) {
            ignore(valuesBuffer.removeLast());
          };
          return #ok (encodingType, hrp, valuesBuffer.toArray());
        };
        case _ {
          #err ("Failed to decode HRP.");
        };
    };
  };

  // Expand HRP for checksum computations by grouping together the first 3 bits
  // of all characters, then a zero, then the last 5 bits of all characters.
  // [a, b] => [a[:3], b[:3]] + [0] + [a[3:], b[3:]].
  func expandHrp(hrp : [Nat8]) : [Nat8] {
    let hrpSize = hrp.size();
    let outputSize = hrpSize * 2 + 1;
    let output = Array.init<Nat8>(outputSize, 0);

    var i : Nat = 0;
    for (currHrp in hrp.vals()) {
      output[i] := currHrp >> 5;
      output[i + hrpSize + 1] := currHrp & 0x1f;
      i += 1;
    };

    return Array.freeze(output);
  };

  // Constant value associated to the given encoding.
  func encodingConstant(encoding : Encoding) : Nat32 {
    return switch(encoding) {
      case (#BECH32) {
        1
      };
      case (#BECH32M) {
        0x2bc830a3
      };
    };
  };

  // Compute the checksum values for given hrp and data.
  func createChecksum(hrp : [Nat8], data : [Nat8], encoding : Encoding) : [Nat8] {
    let expandedHrp : [Nat8] = expandHrp(hrp);

    // Merge expandedHrp and data arrays and append 6 zeroes to get
    // [expandedHrp..., data..., 0, 0, 0, 0, 0, 0].
    let polyModValues : Buffer.Buffer<Nat8> = Buffer.Buffer<Nat8>(
      expandedHrp.size() + data.size() + 6);

    for (val in expandedHrp.vals()) {
      polyModValues.add(val);
    };
    for (val in data.vals()) {
      polyModValues.add(val);
    };

    // Pad with 6 zeros.
    for (_ in Iter.range(0, 5)) {
      polyModValues.add(0);
    };

    let mod : Nat32 = polymod(polyModValues.toArray())
      ^ encodingConstant(encoding);

    // Convert the 5-bit groups in mod to checksum data.
    return Array.tabulate<Nat8>(6, func (i) {
      Nat8.fromIntWrap(Nat32.toNat(
        (mod >> (5 * (5 - Nat32.fromIntWrap(i)))) & 31))
    });
  };

  // Verify the checksum for the given bech32 data.
  func verifyChecksum(hrp : [Nat8], values : [Nat8])
    : Result.Result<Encoding, Text> {

    let expandedHrp : [Nat8] = expandHrp(hrp);

    // Merge expandedHrp and values arrays.
    let polyModValues : Buffer.Buffer<Nat8> = Buffer.Buffer<Nat8>(
      expandedHrp.size() + values.size());

    for (val in expandedHrp.vals()) {
      polyModValues.add(val);
    };
    for (val in values.vals()) {
      polyModValues.add(val);
    };

    let check : Nat32 = polymod(polyModValues.toArray());

    return if (check == encodingConstant(#BECH32)) {
      #ok (#BECH32)
    } else if (check == encodingConstant(#BECH32M)) {
      #ok (#BECH32M)
    } else {
      #err("Checksum verification failed.")
    };
  };

  // Compute 6 5-bit values that make the checksum zero. Input values are
  // coefficients of a polynomial over GF(32) with an implicit 1 in front.
  // Returns the values packed inside a Nat32.
  func polymod(values : [Nat8]) : Nat32 {
    var c : Nat32 = 1;

    for (value in values.vals()) {
      let c0 : Nat8 = Nat8.fromIntWrap(Nat32.toNat(c >> 25));
      c := ((c & 0x1ffffff) << 5) ^ Nat32.fromIntWrap(Nat8.toNat(value));

      // Conditionally add in coefficients of the generator polynomial.
      if (c0 & 1 > 0)  c ^= 0x3b6a57b2;
      if (c0 & 2 > 0)  c ^= 0x26508e6d;
      if (c0 & 4 > 0)  c ^= 0x1ea119fa;
      if (c0 & 8 > 0)  c ^= 0x3d4233dd;
      if (c0 & 16 > 0) c ^= 0x2a1462b3;
    };
    return c;
  };

  // If input corresponds to code of uppercase character, return code of its
  // lowercase version.
  func toLower(c : Nat8) : Nat8 {
    return if (c >= CHAR_A and c <= CHAR_Z) {
      c + 0x20
    } else {
      c
    };
  };

  // Convert given byte value to Text.
  func toText(c : Nat8) : Text {
    return Char.toText(
      Char.fromNat32(
        Nat32.fromNat(
          Nat8.toNat(c)
        )
      )
    );
  };

  // Returns true if given code corresponds to a lowercase character.
  func isLowercase(c : Nat8) : Bool {
    return (c >= CHAR_a and c <= CHAR_z);
  };

  // Returns true if given code corresponds to an uppercase character.
  func isUppercase(c : Nat8) : Bool {
    return (c >= CHAR_A and c <= CHAR_Z);
  };

  // Check if given code is within range of human-readable characters.
  func isInRange(c : Nat8) : Bool {
    return (c >= CHARS_LOWLIMIT and c <= CHARS_HIGHLIMIT);
  };
};
