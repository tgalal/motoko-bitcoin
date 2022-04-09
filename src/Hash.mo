import Ripemd160 "./Ripemd160";
import SHA256 "../motoko-sha/src/SHA256";

module {
  public func hash160(data : [Nat8]) : [Nat8] {
    return Ripemd160.hash(SHA256.sha256(data));
  };
};
