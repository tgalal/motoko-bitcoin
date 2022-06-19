import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Result "mo:base/Result";
import Script "./Script";
import Common "../Common";
import ByteUtils "../ByteUtils";
import Types "./Types";

module {
  // Deserialize TxOutput from data with layout:
  // | amount | serialized script |
  public func fromBytes(data : Iter.Iter<Nat8>)
    : Result.Result<TxOutput, Text> {
    return switch (ByteUtils.readLE64(data), Script.fromBytes(data, true)) {
      case (?amount, #ok script) {
        #ok (TxOutput(amount, script))
      };
      case (?amount, #err (msg)) {
        #err ("Could not decode script: " # msg)
      };
      case (null, _) {
        #err "Could not read TxOut amount"
      };
    };
  };

  // Representation of a TxOutput of a Bitcoin transaction. A TxOutput locks
  // specified amount of Satoshi with the given script.
  public class TxOutput(_amount : Types.Satoshi, _scriptPubKey : Script.Script) {

    public let amount : Types.Satoshi = _amount;
    public let scriptPubKey : Script.Script = _scriptPubKey;

    // Serialize to bytes with layout: | amount | serialized script |
    public func toBytes() : [Nat8] {
      let encodedScript = Script.toBytes(scriptPubKey);
      let totalSize = 8 + encodedScript.size();
      let output = Array.init<Nat8>(totalSize, 0);

      Common.writeLE64(output, 0, amount);
      Common.copy(output, 8, encodedScript, 0, encodedScript.size());

      return Array.freeze(output);
    };
  };
};
