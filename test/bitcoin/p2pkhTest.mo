import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";
import Hash "../../src/Hash";
import TestUtils "../TestUtils";
import Curves "../../src/ec/Curves";
import Script "../../src/bitcoin/Script";
import P2pkh "../../src/bitcoin/P2pkh";
import Types "../../src/bitcoin/Types";
import PublicKey "../../src/ecdsa/Publickey";

type AddressTestCase = {
  key : [Nat8];
  p2pkh : Text;
  network : Types.Network;
};

type MakeScriptTestCase = {
  address : P2pkh.Address;
  expectedBytes : [Nat8];
};

let addressTestData : [AddressTestCase] = [
  {
    key = [
      0x03, 0x87, 0xd8, 0x20, 0x42, 0xd9, 0x34, 0x47, 0x00, 0x8d, 0xfe, 0x2a,
      0xf7, 0x62, 0x06, 0x8a, 0x1e, 0x53, 0xff, 0x39, 0x4a, 0x5b, 0xf8, 0xf6,
      0x8a, 0x04, 0x5f, 0xa6, 0x42, 0xb9, 0x9e, 0xa5, 0xd1
    ];
    p2pkh = "1MmqjDhakEfJd9r5BoDhPApCpA75Em17GA";
    network = #Mainnet;
  },
];

// Test data from:
// https://www.blockchain.com/btc-testnet/tx/245e2d1f87415836cbb7b0bc84e40f4ca1d2a812be0eda381f02fb2224b4ad69
let makeScriptTestCases : [MakeScriptTestCase] = [
  {
    address = "mrFF91kpuRbivucowsY512fDnYt6BWrvx9";
    expectedBytes = [
      0x19, 0x76, 0xa9, 0x14, 0x75, 0xb0, 0xc9, 0xfc, 0x78, 0x4b, 0xa2, 0xea,
      0x08, 0x39, 0xe3, 0xcd, 0xf2, 0x66, 0x94, 0x95, 0xca, 0xc6, 0x70, 0x73,
      0x88, 0xac
    ];
  },
  {
    address = "mnNcaVkC35ezZSgvn8fhXEa9QTHSUtPfzQ";
    expectedBytes = [
      0x19, 0x76, 0xa9, 0x14, 0x4b, 0x35, 0x18, 0x22, 0x9b, 0x0d, 0x35, 0x54,
      0xfe, 0x7c, 0xd3, 0x79, 0x6a, 0xde, 0x63, 0x2a, 0xff, 0x30, 0x69, 0xd8,
      0x88, 0xac
    ];
  },
];

func testP2pkhDeriveAddress(testCase : AddressTestCase) {
  let actual = P2pkh.deriveAddress(testCase.network,
    (testCase.key, Curves.secp256k1));
  assert(testCase.p2pkh == actual);
};

func testP2pkhDecodeAddress(testCase : AddressTestCase) {
  switch (P2pkh.decodeAddress(testCase.p2pkh)) {
    case (#ok {network; publicKeyHash}) {
      assert(testCase.network == network);
      assert(Hash.hash160(testCase.key) == publicKeyHash);
    };
    case (#err msg) {
      Debug.trap(msg);
    };
  };
};

func testMakeScript(testCase : MakeScriptTestCase) {
  switch (P2pkh.makeScript(testCase.address)) {
    case (#ok script) {
      assert(testCase.expectedBytes == Script.toBytes(script));
    };
    case (#err msg) {
      Debug.trap(msg);
    };
  };
};

let runTest = TestUtils.runTestWithDefaults;

runTest({
  title = "P2PKH address derivation";
  fn = testP2pkhDeriveAddress;
  vectors = addressTestData;
});

runTest({
  title = "Decode P2PKH address";
  fn = testP2pkhDecodeAddress;
  vectors = addressTestData;
});

runTest({
  title = "Make P2PKH script";
  fn = testMakeScript;
  vectors = makeScriptTestCases;
});
