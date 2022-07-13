import Debug "mo:base/Debug";
import Array "mo:base/Array";
import Int32 "mo:base/Int32";
import TestCases "./sighashTestVectors";
import TestUtils "../TestUtils";
import Hex "../Hex";
import Script "../../src/bitcoin/Script";
import Transaction "../../src/bitcoin/Transaction";
import Types "../../src/bitcoin/Types";

type TestCase = TestCases.SighashTestCase;
let tests = TestCases.sighashTestCases;
let runTest = TestUtils.runTestWithDefaults;

func test(tcase : TestCase) {
  let hashType = Int32.toNat32(tcase.hashType);
  if (hashType & Types.SIGHASH_ANYONECANPAY > 0) {
    // Skip not supported sighash types.
    return;
  } else if (hashType & 0x1f == Types.SIGHASH_NONE) {
    // Skip not supported sighash types.
    return;
  } else if (hashType & 0x1f == Types.SIGHASH_SINGLE) {
    // Skip not supported sighash types.
    return;
  };

  if (tcase.witness) {
    // Skip not supported witness version.
    return;
  };

  let (txData, scriptData, expectedResult) = switch (
    Hex.decode(tcase.tx),
    Hex.decode(tcase.script),
    Hex.decode(tcase.expectedResult)
  ) {
    case (#ok tx, #ok script, #ok expectedResult) {
      let revExpectedResult = Array.tabulate<Nat8>(expectedResult.size(),
        func (i) {
          expectedResult[expectedResult.size() - 1 - i]
        });
      (tx, script, revExpectedResult)
    };
    case _ {
      Debug.trap("Could not decode test data");
    };
  };

  let (tx, script) = switch (
    Transaction.fromBytes(txData.vals()),
    Script.fromBytes(scriptData.vals(), false)
  ) {
    case (#ok tx, #ok script) {
      (tx, script)
    };
    case (#ok tx, #err msg) {
      Debug.trap("Could not deserialize script data: " # msg);
    };
    case (#err(msg), _) {
      Debug.trap(msg);
    };
  };

  assert(tx.toBytes() == txData);

  let actualSighash = tx.createSignatureHash(script, tcase.inputIndex, hashType);
  assert(expectedResult == actualSighash);
};

runTest({
  title = "Sighash";
  fn = test;
  vectors = tests;
});
