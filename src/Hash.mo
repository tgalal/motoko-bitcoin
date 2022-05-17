import Ripemd160 "./Ripemd160";
import SHA256 "../motoko-sha/src/SHA256";

module {
  // Applies SHA256 followed by RIPEMD160 on the given data.
  public func hash160(data : [Nat8]) : [Nat8] {
    return Ripemd160.hash(SHA256.sha256(data));
  };

  // Applies double SHA256 to input.
  public func doubleSHA256(data : [Nat8]) : [Nat8] {
    return SHA256.sha256(SHA256.sha256(data));
  };
};
