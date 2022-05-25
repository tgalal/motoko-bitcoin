import Result "mo:base/Result";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Array "mo:base/Array";
import Types "./Types";
import Common "../Common";
import ByteUtils "../ByteUtils";

module {
  type DerSignature = Types.DerSignature;
  type Signature = Types.Signature;

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
