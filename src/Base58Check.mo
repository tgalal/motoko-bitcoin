import Array "mo:base/Array";
import Iter "mo:base/Iter";
import SHA256 "../motoko-sha/src/SHA256";
import Base58 "./Base58";

module {

  // Convert the given Base256 input to Base58 with checksum.
  public func encode(input : [Nat8]) : Text {
    // Add 4-byte hash check to the end.
    let hash : [Nat8] = SHA256.sha256(SHA256.sha256(input));
    let inputWithCheck : [var Nat8] = Array.init<Nat8>(input.size() + 4, 0);

    for (i in Iter.range(0, input.size() - 1)) {
        inputWithCheck[i] := input[i];
    };

    inputWithCheck[input.size()] := hash[0];
    inputWithCheck[input.size() + 1] := hash[1];
    inputWithCheck[input.size() + 2] := hash[2];
    inputWithCheck[input.size() + 3] := hash[3];

    return Base58.encode(Array.freeze(inputWithCheck));
  };

  // Convert the given checked Base58 input to Base256. Returns null if the
  // checksum verification fails.
  public func decode(input: Text) : ?[Nat8] {
    let decoded : [Nat8] = Base58.decode(input);

    // Strip the last 4 bytes.
    let output = Array.tabulate<Nat8>(decoded.size() - 4, func(i) {
      decoded[i];
    });

    // Re-calculate checksum, ensure it matches the included 4-byte checksum.
    let hash : [Nat8] = SHA256.sha256(SHA256.sha256(output));

    for (i in Iter.range(0, 3)) {
      if (hash[i] != decoded[decoded.size() - 4 + i]) {
        return null;
      };
    };

    return ?output;
  };
};
