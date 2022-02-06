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
