import Buffer "mo:base/Buffer";
import Blob "mo:base/Blob";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Result "mo:base/Result";
import Nat32 "mo:base/Nat32";
import Nat8 "mo:base/Nat8";
import Transaction "./Transaction";
import Der "../ecdsa/Der";
import Script "./Script";
import EcdsaTypes "../ecdsa/Types";
import PublicKey "../ecdsa/Publickey";
import TxInput "./TxInput";
import TxOutput "./TxOutput";
import Address "./Address";
import Types "./Types";

module {
  type Utxo = Types.Utxo;
  type Satoshi = Types.Satoshi;
  type OutPoint = Types.OutPoint;

  let dustThreshold : Satoshi = 10_000;
  let defaultSequence : Nat32 = 0xffffffff;

  type EcdsaProxy = {
    // Takes a message hash and a derivation path, outputs a signature encoded
    // as the concatenation of big endian representation of r and s values.
    sign : (Blob, [Blob]) -> Blob;
    // Outputs SEC-1 encoded public key and a chain code.
    publicKey : () -> (Blob, Blob);
  };

  // Builds a transaction.
  // `version` is the transaction version. Currently only 1 and 2 are
  // supported.
  // `utxos` is a set of unspent transaction outputs to construct TxInputs from.
  // `destinations` is a list of address-value pairs indicating the amount to
  // transfer to each address.
  // `changeAddress` is an address to return any remaining amount to.
  // `fees` indicate the transaction fees.
  public func buildTransaction(
    version : Nat32, utxos : [Utxo], destinations : [(Types.Address, Satoshi)],
    changeAddress : Types.Address, fees : Satoshi)
    : Result.Result<Transaction.Transaction, Text> {

    if (version != 1 and version != 2) {
      return #err ("Unexpected version number: " # Nat32.toText(version))
    };

    // Collect TxOutputs, making space for a potential extra output for change.
    let txOutputs = Buffer.Buffer<TxOutput.TxOutput>(destinations.size() + 1);
    var totalSpend : Satoshi = fees;

    for (dest in destinations.vals()) {
      let (destAddr, destAmount) = dest;
      switch (Address.scriptPubKey(destAddr)) {
        case (#ok destScriptPubKey) {
          txOutputs.add(TxOutput.TxOutput(destAmount, destScriptPubKey));
          totalSpend += destAmount;
        };
        case (#err msg) {
          return #err msg;
        };
      };
    };

    // Select which UTXOs to spend. For now, we spend the first available
    // UTXOs.
    var availableFunds : Satoshi = 0;
    let txInputs : Buffer.Buffer<TxInput.TxInput> = Buffer.Buffer(utxos.size());

    label UtxoLoop for (utxo in utxos.vals()) {
      availableFunds += utxo.value;
      txInputs.add(TxInput.TxInput(utxo.outpoint, defaultSequence));

      if (availableFunds >= totalSpend) {
        // We have enough inputs to cover the amount we want to spend.
        break UtxoLoop;
      };
    };

    if (availableFunds < totalSpend) {
      return #err "Insufficient balance";
    };

    // If there is remaining amount that is worth considering then include a
    // change TxOutput.
    let remainingAmount : Satoshi = availableFunds - totalSpend;

    if (remainingAmount > dustThreshold) {
      switch (Address.scriptPubKey(changeAddress)) {
        case (#ok chScriptPubKey) {
          txOutputs.add(TxOutput.TxOutput(remainingAmount, chScriptPubKey));
        };
        case (#err msg) {
          return #err msg;
        };
      };
    };

    return #ok (Transaction.Transaction(version,
      txInputs.toArray(), txOutputs.toArray(), 0));
  };

  // Sign given transaction.
  // `sourceAddress` is the spender's address appearing in the TxOutputs being
  // spent from.
  // `ecdsaProxy` is an interface providing ecdsa signing functionality.
  public func signTransaction(sourceAddress : Types.Address,
    transaction : Transaction.Transaction, ecdsaProxy : EcdsaProxy,
    derivationPath : [Blob]
  ) : Result.Result<Transaction.Transaction, Text> {

    // Obtain the scriptPubKey of the source address which is also the
    // scriptPubKey of the Tx output being spent.
    return switch (Address.scriptPubKey(sourceAddress)) {
      case (#ok scriptPubKey) {
        // Obtain scriptSigs for each Tx input.
        let scriptSigs = Array.tabulate<Script.Script>(
          transaction.txInputs.size(), func (i) {
            let sighash : [Nat8] = transaction.createSignatureHash(
              scriptPubKey, Nat32.fromIntWrap(i), Types.SIGHASH_ALL);
              let signature : Blob = ecdsaProxy.sign(
                Blob.fromArray(sighash), derivationPath);
              let encodedSignature : [Nat8] = Blob.toArray(
                Der.encodeSignature(signature));
              // Append the sighash type.
              let encodedSignatureWithSighashType = Array.tabulate<Nat8>(
                encodedSignature.size() + 1, func (n) {
                  if (n < encodedSignature.size()) {
                    encodedSignature[n]
                  } else {
                    Nat8.fromNat(Nat32.toNat(Types.SIGHASH_ALL))
                  };
              });

            // Create Script Sig which looks like:
            // ScriptSig = <Signature> <Public Key>.
            [
              #data encodedSignatureWithSighashType,
              #data (Blob.toArray(ecdsaProxy.publicKey().0))
            ]
          }
        );
        // Assign ScriptSigs to their associated TxInputs.
        for (i in Iter.range(0, scriptSigs.size() - 1)) {
          transaction.txInputs[i].script := scriptSigs[i];
        };

        #ok transaction
      };
      case (#err msg) {
        #err msg
      };
    };
  };

  // Create and sign a transaction.
  // `sourceAddress` is the spender's address appearing in the TxOutputs being
  // spent from.
  // `ecdsaProxy` is an interface for ECDSA signing functionality.
  // `version` is the transaction version. Currently only 1 and 2 are
  // supported.
  // `utxos` is a set of unspent transaction outputs to construct TxInputs from.
  // `destinations` is a list of address-value pairs indicating the amount to
  // transfer to each address.
  // `changeAddress` is an address to return any remaining amount to.
  // `fees` indicate the transaction fees.
  public func createSignedTransaction(
    sourceAddress : Types.Address, ecdsaProxy : EcdsaProxy,
    derivationPath : [Blob], version : Nat32, utxos : [Utxo],
    destinations : [(Types.Address, Satoshi)], changeAddress : Types.Address,
    fees : Satoshi) : Result.Result<Transaction.Transaction, Text> {

    return switch (buildTransaction(version, utxos, destinations,
      changeAddress, fees)) {
      case (#ok transaction) {
        signTransaction(sourceAddress, transaction, ecdsaProxy, derivationPath)
      };
      case (#err msg) {
        #err msg
      };
    };
  };
};
