import Text "mo:base/Text";
import Char "mo:base/Char";
import Nat8 "mo:base/Nat8";
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
