import Buffer "mo:base/Buffer";
import Array "mo:base/Array";

module {
  // Extended Euclidean Algorithm.
  public func eea(a : Int, b : Int) : (Int, Int, Int) {
    if (b == 0) {
      return (a, 1, 0);
    };
    let (d, s, t) = eea(b, a % b);
    return (d, t, s - (a / b) * t);
  };

  public func toBinaryReversed(a: Nat) : [Bool] {
    let bitsBuffer = Buffer.Buffer<Bool>(256);
    var number : Nat = a;

    while (number != 0) {
      bitsBuffer.add(number % 2 == 1);
      number /= 2;
    };

    return bitsBuffer.toArray();
  };

  public func toBinary(a : Nat) : [Bool] {
    let reversedBinary = toBinaryReversed(a);
    return Array.tabulate<Bool>(reversedBinary.size(), func (i) {
      reversedBinary[reversedBinary.size() - i - 1];
    });
  };
};
