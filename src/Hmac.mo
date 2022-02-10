import Array "mo:base/Array";
import SHA256Digest "../motoko-sha/src/SHA256";
import SHA512Digest "../motoko-sha/src/SHA512";

module {
  public type Digest = {
    write : ([Nat8]) -> () ;
    sum : () -> [Nat8];
  };

  public type DigestFactory = {
    blockSize : Nat;
    create : () -> Digest;
  };

  public type Hmac = {
    write : ([Nat8]) -> ();
    sum : () -> [Nat8];
  };

  // Sha256 support.
  object sha256DigestFactory {
    public let blockSize : Nat = 64;
    public func create () : Digest = SHA256Digest.Digest();
  };
  public func sha256(key: [Nat8]) : Hmac = HmacImpl(key, sha256DigestFactory);

  // Sha512 support.
  object sha512DigestFactory {
    public let blockSize : Nat = 128;
    public func create () : Digest = SHA512Digest.Digest();
  };
  public func sha512(key: [Nat8]) : Hmac = HmacImpl(key, sha512DigestFactory);

  // Construct HMAC from an arbitrary digest function.
  public func new(key : [Nat8], digestFactory : DigestFactory) : Hmac {
    return HmacImpl(key, digestFactory);
  };

  // Construct HMAC from the given digest function:
  // HMAC(key, data) = H((key' ^ outerPad) || H((key' ^ innerPad) || data))
  // key' = H(key) if key larger than block size, otherwise equals key
  // H is a cryptographic hash function
  class HmacImpl(key : [Nat8], digestFactory : DigestFactory) : Hmac {
    let innerDigest : Digest = digestFactory.create();
    let outerDigest : Digest = digestFactory.create();
    let innerPad : Nat8 = 0x36;
    let outerPad : Nat8 = 0x5c;

    do {
      let blockSize = digestFactory.blockSize;
      let blockSizedKey : [Nat8] = if (key.size() <= blockSize) {
        // key' = key + [0x00] * (blockSize - key.size())
        Array.tabulate<Nat8>(blockSize, func(i) {
          if (i < key.size()) {
              key[i];
          } else {
              0;
          };
        });
      } else {
        // key' = H(key) + [0x00] * (blockSize - key.size())
        let keyDigest : Digest = digestFactory.create();
        keyDigest.write(key);
        let keyHash = keyDigest.sum();

        Array.tabulate<Nat8>(blockSize, func(i) {
            if (i < keyHash.size()) {
                keyHash[i];
            } else {
                0;
            };
        });
      };

      // H(key' ^ outerPad)
      let outerPaddedKey = Array.map<Nat8, Nat8>(blockSizedKey, func(byte) {
        byte ^ outerPad;
      });
      outerDigest.write(outerPaddedKey);

      // H(key' ^ innerPad)
      let innerPaddedKey = Array.map<Nat8, Nat8>(blockSizedKey, func(byte) {
        byte ^ innerPad;
      });
      innerDigest.write(innerPaddedKey);
    };

    public func write(data : [Nat8]) {
      innerDigest.write(data);
    };

    public func sum() : [Nat8] {
      let innerHash = innerDigest.sum();
      outerDigest.write(innerHash);
      return outerDigest.sum();
    };
  };
}
