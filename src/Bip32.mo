import Common "./Common";
import Hmac "./Hmac";
import Hash "./Hash";
import Base58Check "./Base58Check";
import Curves "./ec/Curves";
import Jacobi "./ec/Jacobi";
import Affine "./ec/Affine";
import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";
import Nat32 "mo:base/Nat32";

module {
  public type Path = {
    #text : Text;
    #array : [Nat32];
  };
  let curve : Curves.Curve = Curves.secp256k1;
  let publicPrefix : Nat32 = 0x0488B21E;

  public func parse(bip32Key : Text, parentPubKey: ?[Nat8])
  : ?ExtendedPublicKey {
    switch(Base58Check.decode(bip32Key)) {
      case (?b58Decoded) {
        let version : Nat32 = Common.readBE32(b58Decoded, 0);
        if (version != publicPrefix) {
          return null;
        };

        let depth : Nat8 = b58Decoded[4];
        let fingerprint : [Nat8] = Array.tabulate<Nat8>(4, func (i) {
          b58Decoded[5 + i];
        });
        let index : Nat32 = Common.readBE32(b58Decoded, 9);

        if (depth == 0) {
          // There should not be a fingerprint since depth is 0.
          if (fingerprint != [0, 0, 0, 0]) {
            return null;
          };
          // Can't have an index > 0 at depth == 0.
          if (index > 0) {
            return null;
          };
        } else {
          switch (parentPubKey) {
            case (?parentPubKey) {
              let parentPubKeyHash = Hash.hash160(parentPubKey);
              for (i in Iter.range(0, 3)) {
                if (parentPubKeyHash[i] != fingerprint[i]) {
                  return null;
                };
              };
            };
            case (null) {
              return null;
            };
          };
        };

        let chaincode = Array.tabulate<Nat8>(32, func (i) {
          b58Decoded[13 + i];
        });

        // Public key must start with 0x02 or 0x03.
        if (b58Decoded[45] != 0x02 and b58Decoded[45] != 0x03) {
          return null;
        };

        let keyData = Array.tabulate<Nat8>(33, func (i) {
          b58Decoded[45 + i];
        });

        let parsedPoint = Affine.fromBytes(keyData, curve);
        if (not Affine.isOnCurve(parsedPoint)) {
          return null;
        };

        return ?ExtendedPublicKey(keyData, chaincode, depth, index,
          parentPubKey);
      };
      case (null) {
        return null;
      };
    };
  };

  func isHardenedIndex(index: Nat32) : Bool {
    return index >= 0x80000000; // 2**31
  };

  func arrayPathFromString(path : Text) : ?[Nat32] {
    // Initial size most suitable for single-digit indices
    let parsedPathBuffer : Buffer.Buffer<Nat32> = Buffer.Buffer(path.size() / 2);

    let sanitized : Text = Text.replace(path, #predicate (func (c) {
      c == '\n' or c == ' ' or c == '\r'
    }), "");

    let tokens : Iter.Iter<Text> = Text.tokens(sanitized, #char '/');
    var first : Bool = true;

    label tokensloop for (token in tokens) {
      if (token == "m") {
        if (first) {
          first := false;
          continue tokensloop;
        };
        return null;
      };
      // Find whether it is hardened
      if (Text.contains(token, #char '\'')) {
        return null;
      };

      switch (Common.textToNat(token)) {
        case (?number) {
           parsedPathBuffer.add(Nat32.fromNat(number));
           first := false;
        };
        case (null) {
          return null;
        };
      };
    };
    return ?parsedPathBuffer.toArray();
  };

  public class ExtendedPublicKey(
    _key: [Nat8],
    _chaincode : [Nat8],
    _depth: Nat8,
    _index: Nat32,
    _parentPublicKey: ?[Nat8]
    ) {

    public let key = _key;
    public let chaincode = _chaincode;
    public let depth = _depth;
    public let index  = _index;
    public let parentPublicKey = _parentPublicKey;

    public func derivePath(path : Path) : ?ExtendedPublicKey {
      return do ? {
        let pathArray : [Nat32] = switch(path) {
          case (#array path) {
            path
          };
          case (#text path) {
            arrayPathFromString(path)!;
          };
        };
        var target : ExtendedPublicKey = ExtendedPublicKey(
          key, chaincode, depth, index, parentPublicKey);

        for (_index in pathArray.vals()) {
          var index = _index;
          if (isHardenedIndex(index)) {
            return null;
          };
          target := target.deriveChild(index);
        };
        target;
      };
    };

    public func deriveChild(index: Nat32) : ExtendedPublicKey {
      assert(not isHardenedIndex(index));

      let hmacData : [var Nat8] = Array.init<Nat8>(37, 0x00);

      Common.copy(hmacData, 0, key, 0, 33);
      Common.writeBE32(hmacData, 33, index);

      let hmacSha512 : Hmac.Hmac = Hmac.sha512(chaincode);
      hmacSha512.write(Array.freeze(hmacData));

      let fullNode : [Nat8] = hmacSha512.sum();
      let leftNode : [Nat8] = Array.tabulate<Nat8>(32, func (i) {
        fullNode[i];
      });
      let leftNodeParsed: Nat = Common.readBE256(leftNode, 0);

      let childKey : [Nat8] =
        Jacobi.toBytes(
          Jacobi.add(
            Jacobi.mulBase(leftNodeParsed, curve),
            Jacobi.fromBytes(key, curve)
          ), true
        );

      let childChaincode: [Nat8] = Array.tabulate<Nat8>(32, func (i) {
        fullNode[i + 32];
      });

      return ExtendedPublicKey(
        childKey,
        childChaincode,
        depth + 1,
        index,
        ?key);
    };

    public func serialize() : Text {
      let result = Array.init<Nat8>(78, 0);

      Common.writeBE32(result, 0, publicPrefix);

      switch(parentPublicKey) {
        case (null) {
          result[4]:= 0x00;
          Common.writeBE64(result, 5, 0x00);
        };
        case (?parentPublicKey) {
          result[4] := depth;
          let fingerprint = Hash.hash160(parentPublicKey);
          Common.copy(result, 5, fingerprint, 0, 4);
          Common.writeBE32(result, 9, index);
        };
      };
      Common.copy(result, 13, chaincode, 0, 32);
      Common.copy(result, 45, key, 0, key.size());

      return Base58Check.encode(Array.freeze(result));
    };
  };
};
