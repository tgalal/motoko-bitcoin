import Array "mo:base/Array";
import Iter "mo:base/Iter";
import SHA256 "../motoko-sha/src/SHA256";
import Base58 "./Base58";

module {
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
};
