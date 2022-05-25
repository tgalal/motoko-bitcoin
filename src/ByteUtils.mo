import Iter "mo:base/Iter";
import Array "mo:base/Array";

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
  // Read one element from the given iterator.
  // Returns null if the iterator does not produce enough data.
  public func readOne(data : Iter.Iter<Nat8>) : ?Nat8 {
    return data.next();
  };
};
