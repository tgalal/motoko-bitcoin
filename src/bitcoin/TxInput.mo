import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Blob "mo:base/Blob";
import Result "mo:base/Result";
import Script "./Script";
import Common "../Common";
import ByteUtils "../ByteUtils";
import Types "./Types";

module {
  // Deserialize a TxInput  from bytes with layout:
  // | prevTxId | prevTx output index | script | sequence |
  public func fromBytes(data : Iter.Iter<Nat8>) : Result.Result<TxInput, Text>{
    let (prevTxId, prevTxOutputIndex, script, sequence) = switch (
      ByteUtils.read(data, 32, false),
      ByteUtils.readLE32(data),
      Script.fromBytes(data, true),
      ByteUtils.readLE32(data)
    ) {
      case (?prevTxId, ?prevTxOutputIndex, #ok script, ?sequence) {
        (Blob.fromArray(prevTxId), prevTxOutputIndex, script, sequence)
      };
      case (null, _, _, _) {
        return #err ("Could not read prevTxId.");
      };
      case (_, null, _, _) {
        return #err ("Could not read prevTxOutputIndex.");
      };
      case (_, _, #err (msg), _) {
        return #err ("Could not deserialize scriptSig: " # msg);
      };
      case (_, _, _, null) {
        return #err ("Could not read sequence.");
      };
    };

    let txIn = TxInput({txid = prevTxId; vout = prevTxOutputIndex}, sequence);
    txIn.script := script;

    return #ok txIn;
  };

  // Representation of a TxInput of a Bitcoin transaction. A TxInput is linked
  // to a previous transaction output given by prevOutput.
  public class TxInput(_prevOutput : Types.OutPoint, _sequence : Nat32) {

    public let prevOutput : Types.OutPoint = _prevOutput;
    public let sequence : Nat32 = _sequence;
    // Unlocking script. This is mutuable to enable signature hash construction
    // for a transaction without having to clone the transaction.
    public var script : Script.Script = [];

    // Serialize to bytes with layout:
    // | prevTxId | prevTx output index | script | sequence |.
    public func toBytes() : [Nat8] {
      let encodedScript = Script.toBytes(script);
      // Total size based on output layout.
      let totalSize = 32 + 4 + encodedScript.size() + 4;
      let output = Array.init<Nat8>(totalSize, 0);
      var outputOffset = 0;

      let prevTxId = Blob.toArray(prevOutput.txid);

      // Write prevTxId.
      Common.copy(output, outputOffset, prevTxId, 0, 32);
      outputOffset += 32;

      // Write prevTx output index.
      Common.writeLE32(output, outputOffset, prevOutput.vout);
      outputOffset += 4;

      // Write script.
      Common.copy(output, outputOffset, encodedScript, 0, encodedScript.size());
      outputOffset += encodedScript.size();

      // Write sequence.
      Common.writeLE32(output, outputOffset, sequence);
      outputOffset += 4;

      assert(outputOffset == output.size());
      return Array.freeze(output);
    };
  };
};
