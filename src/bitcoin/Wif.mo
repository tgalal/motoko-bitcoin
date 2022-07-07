import Iter "mo:base/Iter";
import Result "mo:base/Result";
import Base58Check "../Base58Check";
import ByteUtils "../ByteUtils";
import Common "../Common";
import Types "./Types";

module {
  public type WifPrivateKey = Text;

  // Map network to WIF version prefix.
  func encodeVersion(network : Types.Network) : Nat8 {
    return switch (network) {
      case (#Mainnet) {
        0x80;
      };
      case (#Regtest or #Testnet) {
        0xef;
      };
    };
  };

  // Map WIF version prefix to network.
  func decodeVersion(version : Nat8) : ?Types.Network {
    return switch (version) {
      case (0x80) {
        ?(#Mainnet)
      };
      case (0xef) {
        ?(#Testnet)
      };
      case _ {
        null;
      };
    };
  };

  // Decode WIF private key to extract network, private key,
  // and compression flag.
  public func decode(key : WifPrivateKey)
    : Result.Result<Types.BitcoinPrivateKey, Text> {
    let decoded: Iter.Iter<Nat8> = switch (Base58Check.decode(key)) {
      case (?b58decoded) {
        b58decoded.vals()
      };
      case _ {
        return #err ("Could not base58 decode key.");
      };
    };
    // Split into version || data || compressed.
    let (version, data, compressed) : (Nat8, [Nat8], Bool) =  switch (
      decoded.next(),
      ByteUtils.read(decoded, 32, false),
      decoded.next(),
      decoded.next()){
      case (?version, ?data, ?(0x01), null) {
        (version, data, true)
      };
      case (?version, ?data, null, null) {
        (version, data, false)
      };
      case (_, _, ?(compressionFlag), _) {
        return #err ("Invalid compression flag.");
      };
      case _ {
        return #err ("Invalid key format.");
      };
    };

    let network : Types.Network = switch (decodeVersion(version)) {
      case (?network) {
        network;
      };
      case _ {
        return #err ("Unknown network version.");
      };
    };

    return #ok ({
      network = network;
      key = Common.readBE256(data, 0);
      compressedPublicKey = compressed;
    });
  };
};
