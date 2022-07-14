import Result "mo:base/Result";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat32 "mo:base/Nat32";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Blob "mo:base/Blob";
import Types "./Types";
import Common "../Common";
import ByteUtils "../ByteUtils";

module {
  type DerSignature = Types.DerSignature;
  type Signature = Types.Signature;

  // Serialize signature to DER format:
  // 0x30 [total-length] 0x02 [R-length] [R] 0x02 [S-length] [S]
  func _encodeSignature(r : [Nat8], s : [Nat8]) : DerSignature {
    // Specified value is serialized in big endian with all prefix zeroes
    // stripped, except if the most significant bit of the first non-zero byte
    // is set, then we prepend one zero so that the value is not interpreted as
    // negative.
    func preprocessData(data : [Nat8]) : [Nat8] {
      // Serialize value big endian to 32 byte array.
      let outputBuf = Buffer.Buffer<Nat8>(data.size());

      for (i in Iter.range(0, data.size() - 1)) {
        // We are looking for the first non-zero byte.
        if (outputBuf.size() == 0) {
          // Check whether the current byte is a non-zero.
          if (data[i] != 0) {
            // Check whether the current byte has its msb set.
            if (data[i] >= 0x80) {
              // Msb is set, add zero to output buffer.
              outputBuf.add(0x00);
            };
            // Add the current byte.
            outputBuf.add(data[i]);
          };
        } else {
          // We already found the first non-zero byte and we're just copying
          // subequent bytes into the output buffer.
          outputBuf.add(data[i]);
        };
      };

      return outputBuf.toArray();
    };

    let output = Buffer.Buffer<Nat8>(0);
    let rData : [Nat8] = preprocessData(r);
    let sData : [Nat8] = preprocessData(s);

    // Add DER identifier.
    output.add(0x30);
    // Total size of everything that comes next, excluding sighash type.
    output.add(Nat8.fromIntWrap(
      // DER Sequence identifier: 0x02.
      1
      // Signature r component size.
      + 1
      // Signature r component.
      + rData.size()
      // DER Sequence identifier : 0x02.
      + 1
      // Signature s component size.
      + 1
      // Signature s component.
      + sData.size()
    ));
    // DER sequence identifier.
    output.add(0x02);
    // Signature r component size.
    output.add(Nat8.fromIntWrap(rData.size()));

    // Signature r component.
    for (i in rData.vals()) {
      output.add(i);
    };

    // DER sequence identifier.
    output.add(0x02);
    // Signature s component size.
    output.add(Nat8.fromIntWrap(sData.size()));

    // Signature s component.
    for (i in sData.vals()) {
      output.add(i);
    };

    return Blob.fromArray(output.toArray());
  };

  // Accepts a Blob containing the concatenation of the 32-byte big endian
  // encodings of the two values r and s of the signature.
  // Outputs DER encoding of the signature:
  // 0x30 [total-length] 0x02 [R-length] [R] 0x02 [S-length] [S]
  public func encodeSignature(signature : Blob) : DerSignature {
    let data : [Nat8] = Blob.toArray(signature);
    let rdata = Array.init<Nat8>(32, 0);
    let sdata = Array.init<Nat8>(32, 0);
    Common.copy(rdata, 0, data, 0, 32);
    Common.copy(sdata, 0, data, 32, 32);

    return _encodeSignature(Array.freeze(rdata), Array.freeze(sdata));
  };

  // Decode signature in DER format.
  // 0x30 [total-length] 0x02 [R-length] [R] 0x02 [S-length] [S]
  public func decodeSignature(signature : DerSignature)
    : Result.Result<Signature, Text> {
    let data : Iter.Iter<Nat8> = signature.vals();

    let (totalLen, rLen) = switch (
      ByteUtils.readOne(data),
      ByteUtils.readOne(data),
      ByteUtils.readOne(data),
      ByteUtils.readOne(data)
    ) {
      case (?(0x30), ?totalLen, ?(0x02), ?rLen) {
        (totalLen, rLen);
      };
      case _ {
        return #err ("Could not parse signature.")
      };
    };

    let (rData, sLen) = switch (
      ByteUtils.read(data, Nat8.toNat(rLen), false),
      ByteUtils.readOne(data), ByteUtils.readOne(data)
    ) {
      case (?rData, ?(0x02), ?sLen) {
        (rData, sLen)
      };
      case _ {
        return #err ("Could not parse r sequence.")
      };
    };

    let sData = switch (ByteUtils.read(data, Nat8.toNat(sLen), false)) {
      case (?sData) {
        sData
      };
      case _ {
        return #err ("Could not parse s sequence.")
      };
    };

    if (rData.size() == 0 or rData.size() > 33) {
      return #err ("Invalid r size.")
    };

    if (sData.size() == 0 or sData.size() > 33) {
      return #err ("Invalid s size.")
    };

    if (rData.size() == 33 and rData[0] != 0) {
      return #err ("r value cannot be negative.")
    };

    if (sData.size() == 33 and sData[0] != 0) {
      return #err ("s value cannot be negative.")
    };

    if (totalLen != (rLen + sLen + 4)) {
      return #err ("Wrong total length");
    };

    switch (ByteUtils.readOne(data)) {
      case null {
        // Consumed all bytes.
      };
      case _ {
        return #err ("Did not consume all data");
      };
    };

    let alignedRdata = if (rData.size() < 32) {
      // Align to 32 bytes.
      let aligned : [var Nat8] = Array.init<Nat8>(32, 0);
      for (i in Iter.range(0, Nat.min(rData.size() - 1, 31))) {
        aligned[aligned.size() - 1 - i] := rData[rData.size() - 1 -i];
      };
      Array.freeze(aligned)
    } else {
      rData
    };

    let alignedSdata = if (sData.size() < 32) {
      // Align to 32 bytes.
      let aligned : [var Nat8] = Array.init<Nat8>(32, 0);
      for (i in Iter.range(0, Nat.min(sData.size() - 1, 31))) {
        aligned[aligned.size() - 1 - i] := sData[sData.size() - 1 -i];
      };
      Array.freeze(aligned)
    } else {
      sData
    };

    let r = Common.readBE256(alignedRdata,
      if (alignedRdata.size() == 33) 1 else 0);
    let s = Common.readBE256(alignedSdata,
      if (alignedSdata.size() == 33) 1 else 0);

    return #ok ({r = r; s = s});
  };
};
