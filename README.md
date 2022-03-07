# Algorithms for Bitcoin Integration in Motoko

## Testing

Pull dependencies

```
git submodule update --init
```

Run all tests

```
make test
```

## Usage

Base58:

```motoko
import Base58 "src/Base58";

let encoded : Text = Base58.encode([ /* Nat8 data */ ]);
```

Base58Check:

```motoko
import Base58Check "src/Base58Check";

let encoded : Text = Base58Check.encode([ /* Nat8 data */ ]);
```

HMAC:

```motoko
import Hmac "src/Hmac";

let key : [Nat8] = [ /* Key bytes */ ];

// HMAC-SHA256
let hmacSha256 : Hmac.Hmac = Hmac.sha256(key);
hmacSha256.write([ /* Nat8 data */ ]);
var result : [Nat8] = hmacSha256.sum();

// HMAC-SHA512
let hmacSha512 : Hmac.Hmac = Hmac.sha512(key);
hmacSha512.write([ /* Nat8 data */ ]);
result := hmacSha512.sum();

// HMAC-X
let hmacCustomDigest : Hmac.Hmac = Hmac.new(key, object {
  public let blockSize : Nat = 64;
  public func create() : Hmac.Digest = object {
    public func write(data : [Nat8]) { /* Process input */ };
    public func sum() : [Nat8] = [ /* Compute sum */ ];
  };
});
hmacCustomDigest.write([ /* Nat8 data */ ]);
result := hmacCustomDigest.sum();
```

RIPEMD160:

```motoko
import Ripemd160 "src/Ripemd160";

let digest : Ripemd160.Digest = Ripemd160.Digest();
digest.write([ /* Nat8 data */ ]);
digest.write([ /* Nat8 data */ ]);
let result : [Nat8] = digest.sum();
```

P2PKH Address Derivation

```motoko
import Address "src/Address";

let result : Text = Address.keyToP2pkh([ /* Nat8 data */ ]);
```
