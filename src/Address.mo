import Array "mo:base/Array";
import Base58Check "./Base58Check";
import SHA256 "../motoko-sha/src/SHA256";
import Ripemd160 "./Ripemd160";

module {
  let ADDRESS_TYPE_P2PKH_MAINNET : Nat8 = 0;

  // Convert given public key data to P2PKH format.
  public func keyToP2pkh(key : [Nat8]) : Text {
    let ripemd160Hash : [Nat8] = Ripemd160.hash(SHA256.sha256(key));
    // Prepend version byte.
    let versionedHash : [Nat8] = Array.tabulate<Nat8>(
      ripemd160Hash.size() + 1, func(i) {
        if (i == 0) {
            ADDRESS_TYPE_P2PKH_MAINNET;
        } else {
            ripemd160Hash[i - 1];
        };
    });
    return Base58Check.encode(versionedHash);
  }
};
