import Text "mo:base/Text";
import Char "mo:base/Char";
import Nat8 "mo:base/Nat8";
import Nat32 "mo:base/Nat32";
import Array "mo:base/Array";
import Iter "mo:base/Iter";

module {
  // All alphanumeric characters except for "0", "I", "O", and "l".
  private let base58Alphabet : [Char] = [
    '1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G',
    'H','J','K','L','M','N','P','Q','R','S','T','U','V','W','X','Y','Z',
    'a','b','c','d','e','f','g','h','i','j','k','m','n','o','p','q','r',
    's','t','u','v','w','x','y','z'
  ];

  private let mapBase58 : [Nat8] = [
    255,255,255,255,255,255,255,255, 255,255,255,255,255,255,255,255,
    255,255,255,255,255,255,255,255, 255,255,255,255,255,255,255,255,
    255,255,255,255,255,255,255,255, 255,255,255,255,255,255,255,255, 255, 0,
    1, 2, 3, 4, 5, 6, 7, 8,255,255,255,255,255,255, 255, 9,10,11,12,13,14,15,
    16,255,17,18,19,20,21,255, 22,23,24,25,26,27,28,29,
    30,31,32,255,255,255,255,255, 255,33,34,35,36,37,38,39,
    40,41,42,43,255,44,45,46, 47,48,49,50,51,52,53,54,
    55,56,57,255,255,255,255,255, 255,255,255,255,255,255,255,255,
    255,255,255,255,255,255,255,255, 255,255,255,255,255,255,255,255,
    255,255,255,255,255,255,255,255, 255,255,255,255,255,255,255,255,
    255,255,255,255,255,255,255,255, 255,255,255,255,255,255,255,255,
    255,255,255,255,255,255,255,255, 255,255,255,255,255,255,255,255,
    255,255,255,255,255,255,255,255, 255,255,255,255,255,255,255,255,
    255,255,255,255,255,255,255,255, 255,255,255,255,255,255,255,255,
    255,255,255,255,255,255,255,255, 255,255,255,255,255,255,255,255,
    255,255,255,255,255,255,255,255,
  ];

  // Convert the given Base58 input to Base256.
  public func decode(input : Text) : [Nat8] {
    let inputIter : Iter.Iter<Char> = input.chars();
    var current : ?Char = inputIter.next();
    var spaces : Nat = 0;

    // Skip leading spaces
    label l loop {
      switch(current) {
        case (?' ') {
          spaces := spaces + 1;
        };
        case (_) {
          break l;
        };
      };
      current := inputIter.next();
    };

    // Skip and count leading '1's.
    var zeroes : Nat = 0;
    var length : Nat = 0;

    label l loop {
      switch(current) {
        case (?'1') {
          zeroes := zeroes + 1;
        };
        case (_) {
          break l;
        };
      };
      current := inputIter.next();
    };

    // Compute how many bytes are needed for the Base256 representation. We
    // need log(58) / log(256) of one byte to represent a Base58 digit in
    // Base256, which is approximately 733 / 1000. The input size is multiplied
    // by this value and rounded up to get the total Base256 required size.
    let size : Nat = (input.size() - zeroes - spaces) * 733 / 1000 + 1;
    let b256 : [var Nat8] = Array.init<Nat8>(size, 0x00);

    label l loop {
      switch(current) {
        case (?' ') {
          break l;
        };
        case (null) {
          break l;
        };
        case (?value) {
          var carry : Nat = Nat8.toNat(
            mapBase58[Nat32.toNat(Char.toNat32(value))]);
          assert(carry != 0xff);

          var i : Nat = 0;
          var b256Pointer : Nat = b256.size() - 1;
          label reverseIter while (carry != 0 or i < length) {

            carry += 58 * Nat8.toNat(b256[b256Pointer]);
            b256[b256Pointer] := Nat8.fromNat(carry % 256);
            carry /= 256;
            i += 1;

            if (b256Pointer == 0) {
              break reverseIter;
            };
            b256Pointer -= 1;
          };

          assert(carry == 0);
          length := i;
        };
      };
      current := inputIter.next();
    };

    // Skip trailing spaces.
    label l loop {
      switch(current) {
        case (?' ') {};
        case (_) {
          break l;
        };
      };
      current := inputIter.next();
    };

    // Check all input was consumed.
    assert(current == null);

    // Skip leading zeroes in base256 result.
    var b256Pointer : Nat = size - length;
    while (b256Pointer < b256.size() and b256[b256Pointer] == 0) {
      b256Pointer += 1;
    };

    let output = Array.tabulate<Nat8>(zeroes + b256.size() - b256Pointer,
      func(i) {
        if (i < zeroes) {
          0x00;
        } else {
          b256[i + b256Pointer - zeroes];
        };
    });

    return output;
  };

  // Convert the given Base256 input to Base58.
  public func encode(input : [Nat8]) : Text {
    var zeroes : Nat = 0;
    var length : Nat = 0;
    var inputPointer : Nat = 0;

    // Skip & count leading zeroes.
    while (zeroes < input.size() and input[inputPointer] == 0) {
      zeroes += 1;
      inputPointer += 1;
    };

    // Allocate enough space in big-endian base58 representation:
    // log(256) / log(58), rounded up.
    let size : Nat = (input.size() - inputPointer) * 138 / 100 + 1;
    let b58 : [var Nat8] = Array.init<Nat8>(size, 0);

    while (inputPointer < input.size()) {
      var carry : Nat = Nat8.toNat(input[inputPointer]);
      var i : Nat = 0;
      // Apply "b58 = b58 * 256 + ch".
      var b58Pointer : Nat = b58.size() - 1;
      label reverseIter while (carry != 0 or i < length) {
        carry += 256 * Nat8.toNat((b58[b58Pointer]));
        b58[b58Pointer] := Nat8.fromNat(carry % 58);
        carry /= 58;
        i += 1;
        if (b58Pointer == 0) {
          break reverseIter;
        };
        b58Pointer -= 1;
      };
      assert(carry == 0);
      length := i;
      inputPointer += 1;
    };

    // Skip leading zeroes in base58 result.
    var b58Pointer : Nat = size - length;
    while (b58Pointer < b58.size() and b58[b58Pointer] == 0) { b58Pointer += 1; };

    let output = Array.tabulate<Char>(zeroes + b58.size() - b58Pointer, func(i) {
      if (i < zeroes) {
        Char.fromNat32(0x31);
      } else {
        base58Alphabet[Nat8.toNat(b58[i + b58Pointer - zeroes])];
      };
    });
    return Text.fromIter(output.vals());
  };
};
