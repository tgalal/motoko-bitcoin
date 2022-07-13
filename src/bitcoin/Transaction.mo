import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Nat32 "mo:base/Nat32";
import Blob "mo:base/Blob";
import Result "mo:base/Result";
import Hash "../Hash";
import Script "./Script";
import Common "../Common";
import ByteUtils "../ByteUtils";
import Types "./Types";
import TxInput "./TxInput";
import TxOutput "./TxOutput";

module {
  // Deserialize transaction from data with the following layout:
  // | version | len(txIns) | txIns | len(txOuts) | txOuts | locktime |
  public func fromBytes(data : Iter.Iter<Nat8>)
    : Result.Result<Transaction, Text> {

    // Read version and number of transaction inputs.
    let (version, txInSize) = switch (
      ByteUtils.readLE32(data),
      ByteUtils.readVarint(data)
    ) {
      case (?version, ?txInSize) {
        (version, txInSize)
      };
      case (null, _) {
        return #err ("Could not read version.");
      };
      case (_, null) {
        return #err ("Could not read TxInputs size.");
      };
    };

    // Read transaction inputs.
    let txInputs = Buffer.Buffer<TxInput.TxInput>(txInSize);
    for (_ in Iter.range(0, txInSize - 1)) {
      switch (TxInput.fromBytes(data)) {
        case (#ok txIn) {
          txInputs.add(txIn);
        };
        case (#err (msg)) {
          return #err ("Could not deserialize TxInput: " # msg);
        };
      };
    };

    // Read number of transaction outputs.
    let txOutSize = switch (ByteUtils.readVarint(data)) {
      case (?txOutSize) {
        txOutSize;
      };
      case _ {
        return #err ("Could not read TxOutputs size.");
      };
    };

    // Read transaction outputs.
    let txOutputs = Buffer.Buffer<TxOutput.TxOutput>(txOutSize);
    for (_ in Iter.range(0, txOutSize - 1)) {
      switch (TxOutput.fromBytes(data)) {
        case (#ok txOut) {
          txOutputs.add(txOut);
        };
        case (#err (msg)) {
          return #err ("Could not deserialize TxOutput: " # msg);
        };
      };
    };

    // Read transaction locktime.
    let locktime : Nat32 = switch (ByteUtils.readLE32(data)) {
      case (?locktime) {
        locktime
      };
      case _ {
        return #err ("Could not read locktime.");
      };
    };

    return #ok (Transaction(
      version, txInputs.toArray(), txOutputs.toArray(), locktime));
  };

  // Representation of a Bitcoin transaction.
  public class Transaction(version : Nat32, _txIns : [TxInput.TxInput],
    _txOuts : [TxOutput.TxOutput], locktime : Nat32) {

    public let txInputs : [TxInput.TxInput] = _txIns;
    public let txOutputs : [TxOutput.TxOutput] = _txOuts;

    // Compute the transaction double hashing the transaction and reversing the
    // output.
    public func id() : [Nat8] {
     let doubleHash : [Nat8] = Hash.doubleSHA256(toBytes());
     return Array.tabulate<Nat8>(doubleHash.size(),
       func (n : Nat) {
         doubleHash[doubleHash.size() - 1 - n];
       }
     );
    };

    // Create a signature hash for the given TxIn index.
    // Only SIGHASH_ALL is currently supported.
    // Output: Signature Hash.
    public func createSignatureHash(scriptPubKey : Script.Script,
      txInputIndex : Nat32, sigHashType : Types.SighashType) : [Nat8] {
      let sighashMask : Nat32 = sigHashType & 0x1f;
      assert(sighashMask != Types.SIGHASH_SINGLE);
      assert(sighashMask != Types.SIGHASH_NONE);
      assert(sigHashType & Types.SIGHASH_ANYONECANPAY == 0);

      // Clear scripts for other TxInputs.
      for (i in Iter.range(0, txInputs.size() - 1)) {
        txInputs[i].script := [];
      };

      // Set script for current TxIn to given scriptPubKey.
      txInputs[Nat32.toNat(txInputIndex)].script :=
        Array.filter<Script.Instruction>(scriptPubKey, func (instruction) {
          instruction != #opcode (#OP_CODESEPARATOR)
        });

      // Serialize transaction and append SighashType.
      let txData : [Nat8] = toBytes();
      let output : [var Nat8] = Array.init<Nat8>(txData.size() + 4, 0);

      Common.copy(output, 0, txData, 0, txData.size());
      Common.writeLE32(output, txData.size(), sigHashType);

      return Hash.doubleSHA256(Array.freeze(output));
    };

    // Serialize transaction to bytes with layout:
    // | version | len(txIns) | txIns | len(txOuts) | txOuts | locktime |
    public func toBytes() : [Nat8] {

      // Serialize TxInputs to bytes.
      let serializedTxIns : [[Nat8]] = Array.map<TxInput.TxInput, [Nat8]>(
        txInputs, func (txInput) {
          txInput.toBytes();
        });

      // Serialize TxOutputs to bytes.
      let serializedTxOuts : [[Nat8]] = Array.map<TxOutput.TxOutput, [Nat8]>(
        txOutputs, func (txOutput) {
          txOutput.toBytes();
        });

      // Encode the sizes of TxIns and TxOuts as varint.
      let serializedTxInSize : [Nat8] = ByteUtils.writeVarint(txInputs.size());
      let serializedTxOutSize : [Nat8] = ByteUtils.writeVarint(
        txOutputs.size());

      // Compute total size of all serialized TxInputs.
      let totalTxInSize : Nat = Array.foldLeft<[Nat8], Nat>(
        serializedTxIns, 0, func (total : Nat, serializedTxIn : [Nat8]) {
          total + serializedTxIn.size();
        });

      // Compute total size of all serialized TxOutputs.
      let totalTxOutSize : Nat = Array.foldLeft<[Nat8], Nat>(
        serializedTxOuts, 0, func (total : Nat, serializedTxOut : [Nat8]) {
          total + serializedTxOut.size();
        });

      // Total size of output excluding sigHashType.
      let totalSize : Nat =
        // 4 bytes for version.
        4
        + serializedTxInSize.size()
        + totalTxInSize
        + serializedTxOutSize.size()
        + totalTxOutSize
        // 4 bytes for locktime.
        + 4;
      let output = Array.init<Nat8>(totalSize, 0);
      var outputOffset = 0;

      // Write version.
      Common.writeLE32(output, outputOffset, version);
      outputOffset += 4;

      // Write TxInputs size.
      Common.copy(output, outputOffset, serializedTxInSize, 0,
        serializedTxInSize.size());
      outputOffset += serializedTxInSize.size();

      // Write serialized TxInputs.
      for (serializedTxIn in serializedTxIns.vals()) {
        Common.copy(output, outputOffset, serializedTxIn, 0,
          serializedTxIn.size());
        outputOffset += serializedTxIn.size();
      };

      // Write TxOutputs size.
      Common.copy(output, outputOffset, serializedTxOutSize, 0,
        serializedTxOutSize.size());
      outputOffset += serializedTxOutSize.size();

      // Write serialized TxOutputs.
      for (serializedTxOut in serializedTxOuts.vals()) {
        Common.copy(output, outputOffset, serializedTxOut, 0,
          serializedTxOut.size());
        outputOffset += serializedTxOut.size();
      };

      // Write locktime.
      Common.writeLE32(output, outputOffset, locktime);
      outputOffset += 4;

      assert(outputOffset == output.size());
      return Array.freeze(output);
    };
  };
};
