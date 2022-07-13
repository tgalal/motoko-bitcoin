import Types "./Types";
import EcdsaTypes "../ecdsa/Types";
import Ecdsa "../ecdsa/Ecdsa";
import Base58Check "../Base58Check";
import SHA256 "../../motoko-sha/src/SHA256";
import Ripemd160 "../Ripemd160";
import PublicKey "../ecdsa/Publickey";
import ByteUtils "../ByteUtils";
import Hash "../Hash";
import Script "./Script";
import Array "mo:base/Array";
import Result "mo:base/Result";
import Iter "mo:base/Iter";

module {
  type PublicKey = Ecdsa.PublicKey;
  type Script = Script.Script;

  public type Address = Types.P2PkhAddress;
  public type DecodedAddress = {
    network : Types.Network;
    publicKeyHash : [Nat8];
  };

  // Create P2PKH script for the given P2PKH address.
  public func makeScript(address : Address) : Result.Result<Script, Text> {
    return switch (decodeAddress(address)) {
      case (#ok {network; publicKeyHash}) {
        #ok ([
          #opcode(#OP_DUP),
          #opcode(#OP_HASH160),
          #data(publicKeyHash),
          #opcode(#OP_EQUALVERIFY),
          #opcode(#OP_CHECKSIG)
        ]);
      };
      case (#err msg) {
        #err msg
      };
    };
  };

  // Map given network to its id.
  func encodeVersion(network : Types.Network) : Nat8 {
    return switch (network) {
      case (#Mainnet) {
        0x00;
      };
      case (#Regtest or #Testnet) {
        0x6f;
      };
    };
  };

  // Derive P2PKH address from given public key.
  public func deriveAddress(network : Types.Network,
    sec1PublicKey : EcdsaTypes.Sec1PublicKey) : Address {

    let (pkData, _) = sec1PublicKey;
    let ripemd160Hash : [Nat8] = Hash.hash160(pkData);
    let versionedHash : [Nat8] = Array.tabulate<Nat8>(
      ripemd160Hash.size() + 1, func(i) {
        if (i == 0) {
            encodeVersion(network);
        } else {
            ripemd160Hash[i - 1];
        };
    });
    return Base58Check.encode(versionedHash);
  };

  // Decode P2PKH hash into its network and public key hash components.
  public func decodeAddress(address: Address)
    : Result.Result<DecodedAddress, Text> {

    let decoded: Iter.Iter<Nat8> = switch (Base58Check.decode(address)) {
      case (?b58decoded) {
        b58decoded.vals()
      };
      case _ {
        return #err ("Could not base58 decode address.");
      };
    };

    return switch (decoded.next(), ByteUtils.read(decoded, 20, false)) {
      case (?(0x00), ?publicKeyHash) {
        #ok {network = #Mainnet; publicKeyHash = publicKeyHash}
      };
      case (?(0x6f), ?publicKeyHash) {
        #ok {network = #Testnet; publicKeyHash = publicKeyHash}
      };
      case (?(networkId), ?_) {
        #err ("Unrecognized network id.")
      };
      case _ {
        #err ("Could not decode address.")
      };
    };
  };
};
