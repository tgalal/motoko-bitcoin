import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Common "./Common";

module {
  // Read a number of elements from the given iterator and return as array. If
  // reverse is true, will read return the elements in reverse order.
  // Returns null if the iterator does not produce enough data.
  public func read(data : Iter.Iter<Nat8>, count : Nat,
    reverse : Bool) : ?[Nat8] {
    return do ? {
      let readData : [var Nat8] = Array.init<Nat8>(count, 0);
      if (reverse) {
        var nextReadIndex : Nat = count - 1;

        label Loop loop {
          readData[nextReadIndex] := data.next()!;
          if (nextReadIndex == 0) {
            break Loop;
          };
          nextReadIndex -= 1;
        };
      } else {
        var nextReadIndex : Nat = 0;

        while (nextReadIndex < count) {
          readData[nextReadIndex] := data.next()!;
          nextReadIndex += 1;
        };
      };

      Array.freeze(readData);
    };
  };

  // Read little endian 16-bit natural number starting at offset.
  // Returns null if the iterator does not produce enough data.
  public func readLE16(data : Iter.Iter<Nat8>) : ?Nat16 {
    return (do ? {
      let (a, b) = (data.next()!, data.next()!);
      Nat16.fromIntWrap(Nat8.toNat(b)) << 8 |
      Nat16.fromIntWrap(Nat8.toNat(a));
    });
  };

  // Read little endian 32-bit natural number starting at offset.
  // Returns null if the iterator does not produce enough data.
  public func readLE32(data : Iter.Iter<Nat8>) : ?Nat32 {
    return (do ? {
      let (a, b ,c ,d) =
        (data.next()!, data.next()!, data.next()!, data.next()!);
      Nat32.fromIntWrap(Nat8.toNat(d)) << 24 |
      Nat32.fromIntWrap(Nat8.toNat(c)) << 16 |
      Nat32.fromIntWrap(Nat8.toNat(b)) << 8 |
      Nat32.fromIntWrap(Nat8.toNat(a));
    });
  };

  // Read little endian 64-bit natural number starting at offset.
  // Returns null if the iterator does not produce enough data.
  public func readLE64(data : Iter.Iter<Nat8>) : ?Nat64 {
    return (do ? {
      let (a, b, c, d, e, f, g, h) = (
        data.next()!, data.next()!, data.next()!, data.next()!,
        data.next()!, data.next()!, data.next()!, data.next()!
      );

      Nat64.fromIntWrap(Nat8.toNat(h)) << 56 |
      Nat64.fromIntWrap(Nat8.toNat(g)) << 48 |
      Nat64.fromIntWrap(Nat8.toNat(f)) << 40 |
      Nat64.fromIntWrap(Nat8.toNat(e)) << 32 |
      Nat64.fromIntWrap(Nat8.toNat(d)) << 24 |
      Nat64.fromIntWrap(Nat8.toNat(c)) << 16 |
      Nat64.fromIntWrap(Nat8.toNat(b)) << 8 |
      Nat64.fromIntWrap(Nat8.toNat(a));
    });
  };

  // Read one element from the given iterator.
  // Returns null if the iterator does not produce enough data.
  public func readOne(data : Iter.Iter<Nat8>) : ?Nat8 {
    return data.next();
  };

  // Read and return a varint encoded integer from data.
  // Returns null if the iterator does not produce enough data.
  public func readVarint(data : Iter.Iter<Nat8>) : ?Nat {
    return (do ? {
      switch (readOne(data)!) {
        case 0xfd {
          Nat16.toNat(readLE16(data)!)
        };
        case 0xfe {
          Nat32.toNat(readLE32(data)!)
        };
        case 0xff {
          Nat64.toNat(readLE64(data)!)
        };
        case (length) {
          Nat8.toNat(length)
        };
      };
    });
  };

  // Encode value as varint.
  public func writeVarint(value : Nat) : [Nat8] {
    assert(value < 0x10000000000000000);

    return if (value < 0xfd) {
      [Nat8.fromIntWrap(value)]
    } else if (value < 0x10000) {
      let result = Array.init<Nat8>(3, 0xfd);
      Common.writeLE16(result, 1, Nat16.fromIntWrap(value));
      Array.freeze(result)
    } else if (value < 0x100000000) {
      let result = Array.init<Nat8>(5, 0xfe);
      Common.writeLE32(result, 1, Nat32.fromIntWrap(value));
      Array.freeze(result)
    } else {
      let result = Array.init<Nat8>(9, 0xff);
      Common.writeLE64(result, 1, Nat64.fromIntWrap(value));
      Array.freeze(result)
    };
  };
};
