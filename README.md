# Algorithms for Bitcoin Integration in Motoko

## Testing

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
