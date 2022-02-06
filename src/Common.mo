import Nat8 "mo:base/Nat8";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";

module {
  // Read little endian 32-bit natural number starting at offset.
  public func readLE32(bytes : [Nat8], offset : Nat) : Nat32 {
    Nat32.fromIntWrap(Nat8.toNat(bytes[offset + 3])) << 24 |
      Nat32.fromIntWrap(Nat8.toNat(bytes[offset + 2])) << 16 |
      Nat32.fromIntWrap(Nat8.toNat(bytes[offset + 1])) << 8 |
      Nat32.fromIntWrap(Nat8.toNat(bytes[offset + 0]));
  };

  // Write given value little endian into array starting at offset. 
  public func writeLE32(bytes : [var Nat8], offset : Nat, value : Nat32) {
    bytes[offset + 3] := Nat8.fromNat(Nat32.toNat((value & 0xFF000000) >> 24));
    bytes[offset + 2] := Nat8.fromNat(Nat32.toNat((value & 0xFF0000) >> 16));
    bytes[offset + 1] := Nat8.fromNat(Nat32.toNat((value & 0xFF00) >> 8));
    bytes[offset] := Nat8.fromNat(Nat32.toNat((value & 0xFF)));
  };

  // Write given value little endian into array starting at offset.
  public func writeLE64(bytes : [var Nat8], offset : Nat, value : Nat64) {
    bytes[offset + 7] :=
      Nat8.fromNat(Nat64.toNat((value & 0xFF00000000000000) >> 56));
    bytes[offset + 6] :=
      Nat8.fromNat(Nat64.toNat((value & 0xFF000000000000) >> 48));
    bytes[offset + 5] :=
      Nat8.fromNat(Nat64.toNat((value & 0xFF0000000000) >> 40));
    bytes[offset + 4] :=
      Nat8.fromNat(Nat64.toNat((value & 0xFF00000000) >> 32));
    bytes[offset + 3] := Nat8.fromNat(Nat64.toNat((value & 0xFF000000) >> 24));
    bytes[offset + 2] := Nat8.fromNat(Nat64.toNat((value & 0xFF0000) >> 16));
    bytes[offset + 1] := Nat8.fromNat(Nat64.toNat((value & 0xFF00) >> 8));
    bytes[offset] := Nat8.fromNat(Nat64.toNat((value & 0xFF)));
  };
};
