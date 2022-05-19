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

EC

```motoko
import Jacobi "src/ec/Jacobi";
import Affine "src/ec/Affine";
import Curves "src/ec/Curves";

// Get secp256k1 curve parameters.
let secp256k1 : Curves.Curve = Curves.secp256k1;
let Fp = secp256k1.Fp;

// Create affine point on the secp256k1 curve
let basePointAffine : Affine.Point = #point (Fp(secp256k1.gx), Fp(secp256k1.gy), secp256k1);
// Convert to Jacobi point
let basePointJacobi : Jacobi.Point = Jacobi.fromAffine(basePointAffine);

// Scalar multiplication
let mul1 = Jacobi.mul(basePointJacobi, 1234);
let mul2 = Jacobi.mulBase(1234, Curves.secp256k1);

assert(Jacobi.isEqual(mul1, mul2));
```

Bip32

```motoko
import Bip32 "src/Bip32";

let rootKey : ?Bip32.ExtendedPublicKey = Bip32.parse("xpub661MyMwAqRbcFtXgS5sYJABqqG9YLmC4Q1Rdap9gSE8NqtwybGhePY2gZ29ESFjqJoCu1Rupje8YtGqsefD265TMg7usUDFdp6W1EGMcet8", null);

do ? {
  let derived : ?Bip32.ExtendedPublicKey = rootKey!.derivePath(#text "m/1/2/3");
  derived!;
};

```

Bech32:

```motoko
import Bech32 "src/Bech32";

Bech32.encode("bc", [ /* Nat8 data */ ], #BECH32);
Bech32.decode("bc", "bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4");
```

Segwit:

```motoko
import Segwit "src/Segwit";

Segwit.encode("bc", /* WitnessProgram */ );
Segwit.decode("bc", "BC1QW508D6QEJXTDG4Y5R3ZARVARY0C5XW7KV8F3T4");
```
