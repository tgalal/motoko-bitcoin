import Bitcoin "../../src/bitcoin/Bitcoin";
import Transaction "../../src/bitcoin/Transaction";
import Types "../../src/bitcoin/Types";
import Base58Check "../../src/Base58Check";
import Script "../../src/bitcoin/Script";
import Address "../../src/bitcoin/Address";
import Wif "../../src/bitcoin/Wif";
import Jacobi "../../src/ec/Jacobi";
import Curves "../../src/ec/Curves";
import TestUtils "../TestUtils";
import Hex "../Hex";
import BitcoinTestTools "./bitcoinTestTools";
import Array "mo:base/Array";
import Result "mo:base/Result";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import Blob "mo:base/Blob";

let runTest = TestUtils.runTestWithDefaults;

type TestUtxo = {
  txid : Text;
  vout : Nat32;
  value : Types.Satoshi;
};

type TestTxInput = {
  txid : Text;
  vout : Nat32;
};

type TestTxOutput = {
  amount : Types.Satoshi;
  address : Types.Address;
};

type SignTransactionTestCase = {
  privateKey : Wif.WifPrivateKey;
  signingNonces : [Nat];
  utxos : [TestUtxo];
  destinations : [(Types.Address, Types.Satoshi)];
  changeAddress : Types.Address;
  fees : Types.Satoshi;
  result : Bool;
  expectedTxData : Text;
  expectedInputs : [TestTxInput];
  expectedOutputs : [TestTxOutput];
};

// Signing test cases. the field `expectedTxData` is the serialized transaction
// after signature(s). This was obtained by running `bitcoin-tx -create` from
// bitcoin core with the privateKey, expectedInputs, and expectedOutputs test
// data as parameters. Txids are specified in RPC byte-order (big endian) and
// must be converted to internal byte-order (little endian) before usage.
let signTestCases : [SignTransactionTestCase] = [
  {
    // Basic test on mainnet.
    privateKey = "5Hpc6Bu8bs61vTkVxoDKHchQD3J21vHrxJHBe8iSJeNixQusy7i";
    signingNonces = [
      0xb725d37c71d603b0cb927a3f3230b22e712792c07d8e7d8128513ce85756510b
    ];
    expectedTxData = "0100000001e783099a2e5741c43144842c3c1114146328dcae006bf9130eac5d83ada4ff91000000008a47304402202df4128f8218dd9eb1e68701c490029275dadac00b8bc949173075293eb4ab6b02206ad83b56621699a1ca38f4b2046e9bc3f15fc9bd90831c7540246a31b8eac5600141042e03be3dd4412f533053525bfdbb591f8a39f277bb60fdf07f1a1b7398f70a2943afc99066273c39c09a6e4f87b27058385ae2fec3c5e403dd7a8322cd1bf6f1ffffffff01a0860100000000001976a9145834479edbbe0539b31ffd3a8f8ebadc2165ed0188ac00000000";
    utxos = [
      {
        txid = "91ffa4ad835dac0e13f96b00aedc28631414113c2c844431c441572e9a0983e7";
        vout = 0;
        value = 100000
      }
    ];
    destinations = [
      (#p2pkh "193P6LtvS4nCnkDvM9uXn1gsSRqh4aDAz7", 100000)
    ];
    changeAddress = #p2pkh "193P6LtvS4nCnkDvM9uXn1gsSRqh4aDAz7";
    fees = 0;
    result = true;
    expectedInputs = [
      {
        txid = "91ffa4ad835dac0e13f96b00aedc28631414113c2c844431c441572e9a0983e7";
        vout = 0
      }
    ];
    expectedOutputs = [
      {
        amount = 100000;
        address = (#p2pkh "193P6LtvS4nCnkDvM9uXn1gsSRqh4aDAz7")
      }
    ];
  },
  {
    // Change address not used as there are no change.
    privateKey = "92Qba5hnyWSn5Ffcka56yMQauaWY6ZLd91Vzxbi4a9CCetaHtYj";
    signingNonces = [
      0x7c0cb67d4e44a0cc912179a48dec46b468282a16bcbe3772e7634d11e9db5eb6
    ];
    expectedTxData = "010000000169adb42422fb021f38da0ebe12a8d2a14c0fe484bcb0b7cb365841871f2d5e24000000008a47304402206687b866b6a69043b8daee2254126811fe9a09dc7725150456612f78d6b303a3022000e5fbe2ebab1ca416cbaf0801e61e107ea42e6e0168e713c43291a82edd75f00141044289801366bcee6172b771cf5a7f13aaecd237a0b9a1ff9d769cabc2e6b70a34cec320a0565fb7caf11b1ca2f445f9b7b012dda5718b3cface369ee3a034ded6ffffffff0150c30000000000001976a9140ce17649c1306c291ca9e587f8793b5b06563cea88ac00000000";
    utxos = [
      {
        txid = "245e2d1f87415836cbb7b0bc84e40f4ca1d2a812be0eda381f02fb2224b4ad69";
        vout = 0;
        value = 50_000;
      },
    ];
    destinations = [(#p2pkh "mgh4VjZx5MpkHRis9mDsF2ZcKLdXoP3oQ4", 50_000)];
    changeAddress = #p2pkh "mrFF91kpuRbivucowsY512fDnYt6BWrvx9";
    fees = 0;
    result = true;
    expectedInputs = [
      {
        txid = "245e2d1f87415836cbb7b0bc84e40f4ca1d2a812be0eda381f02fb2224b4ad69";
        vout = 0;
      }
    ];
    expectedOutputs = [
      {
        amount = 50_000;
        address = #p2pkh "mgh4VjZx5MpkHRis9mDsF2ZcKLdXoP3oQ4";
      }
    ];
  },
  {
    // Change address not used as there are no change.
    privateKey = "92Qba5hnyWSn5Ffcka56yMQauaWY6ZLd91Vzxbi4a9CCetaHtYj";
    signingNonces = [
      0x14b8d27777406c2b6656af0f389c7aad36da54a808ba5147cec34e304616be95,
      0xf0aeb1a9f75d3c169f4a7f718da3367015c841e0777763086cafd39cc30ca2b8
    ];
    expectedTxData = "010000000269adb42422fb021f38da0ebe12a8d2a14c0fe484bcb0b7cb365841871f2d5e24000000008a47304402202463ff606fdc438487a942d2190c982fe3bc81cae077b2f55904716dd6edc63002200e84e69bf5906ae3e2ecbaf5958d71b9a3cbab10cc7382ad7145b95f2310c03d0141044289801366bcee6172b771cf5a7f13aaecd237a0b9a1ff9d769cabc2e6b70a34cec320a0565fb7caf11b1ca2f445f9b7b012dda5718b3cface369ee3a034ded6ffffffffbe1ae4191d5f84e13d288434d9c21b374d73efe05636a0acd983c0577b3618a7010000008a47304402201a35a6c357f6ef1d935411b9995ee3bd4809fbefd165cb08bb919212a24f9e7402206b768b7b6e08f982e0a064d662bcdc635aaaaa97c3ae6cd4ba4033e9f9ab9aa60141044289801366bcee6172b771cf5a7f13aaecd237a0b9a1ff9d769cabc2e6b70a34cec320a0565fb7caf11b1ca2f445f9b7b012dda5718b3cface369ee3a034ded6ffffffff0118730100000000001976a9140ce17649c1306c291ca9e587f8793b5b06563cea88ac00000000";
    utxos = [
      {
        txid = "245e2d1f87415836cbb7b0bc84e40f4ca1d2a812be0eda381f02fb2224b4ad69";
        vout = 0;
        value = 50_000;
      }, {
        txid = "a718367b57c083d9aca03656e0ef734d371bc2d93484283de1845f1d19e41abe";
        vout = 1;
        value = 47_500;
      }
    ];
    destinations = [(#p2pkh "mgh4VjZx5MpkHRis9mDsF2ZcKLdXoP3oQ4", 95_000)];
    changeAddress = #p2pkh "mrFF91kpuRbivucowsY512fDnYt6BWrvx9";
    fees = 2_500;
    result = true;
    expectedInputs = [
      {
        txid = "245e2d1f87415836cbb7b0bc84e40f4ca1d2a812be0eda381f02fb2224b4ad69";
        vout = 0;
      },
      {
        txid = "a718367b57c083d9aca03656e0ef734d371bc2d93484283de1845f1d19e41abe";
        vout = 1;
      }
    ];
    expectedOutputs = [
      {
        amount = 95_000;
        address = #p2pkh "mgh4VjZx5MpkHRis9mDsF2ZcKLdXoP3oQ4";
      }
    ];
  },
  {
    // Uses change address.
    privateKey = "92Qba5hnyWSn5Ffcka56yMQauaWY6ZLd91Vzxbi4a9CCetaHtYj";
    signingNonces = [
      0x9ed69645a0b02a8a849aac83d51e8bd7b29dce7df8e3a734e0929d619bfca662,
      0x2a83d782fda3749914f80edef8d8042a79c6a0368612afae62fafa42fdaa8d88
    ];
    expectedTxData = "010000000269adb42422fb021f38da0ebe12a8d2a14c0fe484bcb0b7cb365841871f2d5e24020000008a47304402202b73718e88fb2b24ad04990aaf5832238d8b5d181bdba22d6fe4ff788622397f02202cdb4a4ff2d9bde5caeb0c3d3f530fbc0721736e611f504276363a9aeb4678ba0141044289801366bcee6172b771cf5a7f13aaecd237a0b9a1ff9d769cabc2e6b70a34cec320a0565fb7caf11b1ca2f445f9b7b012dda5718b3cface369ee3a034ded6ffffffffbe1ae4191d5f84e13d288434d9c21b374d73efe05636a0acd983c0577b3618a7050000008a47304402204d8446103ca7bc3cc2bcdca11ae1daf0f7d3e86b4d823898728edd27aa184d590220238772aedaaa3adabaf5f540fd1504fbd2212f2f4afd609860b11a0f796814840141044289801366bcee6172b771cf5a7f13aaecd237a0b9a1ff9d769cabc2e6b70a34cec320a0565fb7caf11b1ca2f445f9b7b012dda5718b3cface369ee3a034ded6ffffffff02f8240100000000001976a9140ce17649c1306c291ca9e587f8793b5b06563cea88ac204e0000000000001976a91475b0c9fc784ba2ea0839e3cdf2669495cac6707388ac00000000";
    utxos = [
      {
        txid = "245e2d1f87415836cbb7b0bc84e40f4ca1d2a812be0eda381f02fb2224b4ad69";
        vout = 2;
        value = 50_000;
      }, {
        txid = "a718367b57c083d9aca03656e0ef734d371bc2d93484283de1845f1d19e41abe";
        vout = 5;
        value = 47_500;
      }
    ];
    destinations = [(#p2pkh "mgh4VjZx5MpkHRis9mDsF2ZcKLdXoP3oQ4", 75_000)];
    changeAddress = #p2pkh "mrFF91kpuRbivucowsY512fDnYt6BWrvx9";
    fees = 2_500;
    result = true;
    expectedInputs = [
      {
        txid = "245e2d1f87415836cbb7b0bc84e40f4ca1d2a812be0eda381f02fb2224b4ad69";
        vout = 2;
      },
      {
        txid = "a718367b57c083d9aca03656e0ef734d371bc2d93484283de1845f1d19e41abe";
        vout = 5;
      }
    ];
    expectedOutputs = [
      {
        amount = 75_000;
        address = #p2pkh "mgh4VjZx5MpkHRis9mDsF2ZcKLdXoP3oQ4";
      },
      {
        amount = 20_000;
        address = #p2pkh "mrFF91kpuRbivucowsY512fDnYt6BWrvx9";
      }
    ];
  },
  {
    // Change address not used due to very small change.
    privateKey = "92Qba5hnyWSn5Ffcka56yMQauaWY6ZLd91Vzxbi4a9CCetaHtYj";
    signingNonces = [
      0xfe3e0315ba63c5eb89f32512336f395257815f7d5bde002bc5f7fc26c207a56e
    ];
    expectedTxData = "0100000001be1ae4191d5f84e13d288434d9c21b374d73efe05636a0acd983c0577b3618a7020000008a47304402201d76d5900e0995b7ec4608aa25f17341d71c244945b4da737d1577714258d13e02205be11d2a9bc5bdda05562cee878d8dd0779bee27ab8b6f2f0e12b0cae91149780141044289801366bcee6172b771cf5a7f13aaecd237a0b9a1ff9d769cabc2e6b70a34cec320a0565fb7caf11b1ca2f445f9b7b012dda5718b3cface369ee3a034ded6ffffffff017d920000000000001976a9140ce17649c1306c291ca9e587f8793b5b06563cea88ac00000000";
    utxos = [
      {
        txid = "a718367b57c083d9aca03656e0ef734d371bc2d93484283de1845f1d19e41abe";
        vout = 2;
        value = 50_000;
      }
    ];
    destinations = [(#p2pkh "mgh4VjZx5MpkHRis9mDsF2ZcKLdXoP3oQ4", 37_501)];
    changeAddress = #p2pkh "mrFF91kpuRbivucowsY512fDnYt6BWrvx9";
    fees = 2_500;
    result = true;
    expectedInputs = [
      {
        txid = "a718367b57c083d9aca03656e0ef734d371bc2d93484283de1845f1d19e41abe";
        vout = 2;
      },
    ];
    expectedOutputs = [
      {
        amount = 37_501;
        address = #p2pkh "mgh4VjZx5MpkHRis9mDsF2ZcKLdXoP3oQ4";
      },
    ];
  },
  {
    // Change right above threshold.
    privateKey = "92Qba5hnyWSn5Ffcka56yMQauaWY6ZLd91Vzxbi4a9CCetaHtYj";
    signingNonces = [
      0x271fa97f95ace9660189cadf4d5915933fa60f04d23baf6ad3430e57c72ef115
    ];
    expectedTxData = "0100000001be1ae4191d5f84e13d288434d9c21b374d73efe05636a0acd983c0577b3618a7020000008a473044022046b686e38f604f0059566f5e9273647924264d2a32c3a2d469d9d3577aa14eee022013d6951bda2fe499ee2bd53cc767bfa7dc896bb70809808a25960707aad6647e0141044289801366bcee6172b771cf5a7f13aaecd237a0b9a1ff9d769cabc2e6b70a34cec320a0565fb7caf11b1ca2f445f9b7b012dda5718b3cface369ee3a034ded6ffffffff027b920000000000001976a9140ce17649c1306c291ca9e587f8793b5b06563cea88ac11270000000000001976a91475b0c9fc784ba2ea0839e3cdf2669495cac6707388ac00000000";
    utxos = [
      {
        txid = "a718367b57c083d9aca03656e0ef734d371bc2d93484283de1845f1d19e41abe";
        vout = 2;
        value = 50_000;
      }
    ];
    destinations = [(#p2pkh "mgh4VjZx5MpkHRis9mDsF2ZcKLdXoP3oQ4", 37_499)];
    changeAddress = #p2pkh "mrFF91kpuRbivucowsY512fDnYt6BWrvx9";
    fees = 2_500;
    result = true;
    expectedInputs = [
      {
        txid = "a718367b57c083d9aca03656e0ef734d371bc2d93484283de1845f1d19e41abe";
        vout = 2;
      },
    ];
    expectedOutputs = [
      {
        amount = 37_499;
        address = #p2pkh "mgh4VjZx5MpkHRis9mDsF2ZcKLdXoP3oQ4";
      },
      {
        amount = 10_001;
        address = #p2pkh "mrFF91kpuRbivucowsY512fDnYt6BWrvx9";
      }
    ];
  },
  {
    // Send to multiple destinations
    privateKey = "92Qba5hnyWSn5Ffcka56yMQauaWY6ZLd91Vzxbi4a9CCetaHtYj";
    signingNonces = [
      0x56EE975E3B95A45BDD2A67B784317F604DAC089A3BB163842F5E00A7FCBDCBA1,
      0x22CDAC2D9404D0C45AC3223801D0AF2012DBD7724EE4AB0E9217B355A8C42166
    ];
    expectedTxData = "010000000269adb42422fb021f38da0ebe12a8d2a14c0fe484bcb0b7cb365841871f2d5e24000000008a47304402203bdb2824855f9a286e24ff2975a64fbeb3439a14d905617e13727ee2207afa4702204caebd9d395ec6e150756c7a997b06b2249ac20ac351438e6544d1078e655c920141044289801366bcee6172b771cf5a7f13aaecd237a0b9a1ff9d769cabc2e6b70a34cec320a0565fb7caf11b1ca2f445f9b7b012dda5718b3cface369ee3a034ded6ffffffffbe1ae4191d5f84e13d288434d9c21b374d73efe05636a0acd983c0577b3618a7010000008a4730440220729d9edf15e857046f1f31c3dfab19546036af632d2a0f5319a0cb6dbfc30a350220666653b9548dd12844906d3770bcbeae96858a57c0e2ed6f8e2d52802df671600141044289801366bcee6172b771cf5a7f13aaecd237a0b9a1ff9d769cabc2e6b70a34cec320a0565fb7caf11b1ca2f445f9b7b012dda5718b3cface369ee3a034ded6ffffffff0430750000000000001976a9140ce17649c1306c291ca9e587f8793b5b06563cea88ac10270000000000001976a91475b0c9fc784ba2ea0839e3cdf2669495cac6707388acb8880000000000001976a9144b3518229b0d3554fe7cd3796ade632aff3069d888ac204e0000000000001976a91475b0c9fc784ba2ea0839e3cdf2669495cac6707388ac00000000";
    utxos = [
      {
        txid = "245e2d1f87415836cbb7b0bc84e40f4ca1d2a812be0eda381f02fb2224b4ad69";
        vout = 0;
        value = 50_000;
      }, {
        txid = "a718367b57c083d9aca03656e0ef734d371bc2d93484283de1845f1d19e41abe";
        vout = 1;
        value = 47_500;
      }
    ];
    destinations = [
      (#p2pkh "mgh4VjZx5MpkHRis9mDsF2ZcKLdXoP3oQ4", 30_000),
      (#p2pkh "mrFF91kpuRbivucowsY512fDnYt6BWrvx9", 10_000),
      (#p2pkh "mnNcaVkC35ezZSgvn8fhXEa9QTHSUtPfzQ", 35_000)
    ];
    changeAddress = #p2pkh "mrFF91kpuRbivucowsY512fDnYt6BWrvx9";
    fees = 2_500;
    result = true;
    expectedInputs = [
      {
        txid = "245e2d1f87415836cbb7b0bc84e40f4ca1d2a812be0eda381f02fb2224b4ad69";
        vout = 0;
      },
      {
        txid = "a718367b57c083d9aca03656e0ef734d371bc2d93484283de1845f1d19e41abe";
        vout = 1;
      }
    ];
    expectedOutputs = [
      {
        amount = 30_000;
        address = #p2pkh "mgh4VjZx5MpkHRis9mDsF2ZcKLdXoP3oQ4";
      },
      {
        amount = 10_000;
        address = #p2pkh "mrFF91kpuRbivucowsY512fDnYt6BWrvx9";
      },
      {
        amount = 35_000;
        address = #p2pkh "mnNcaVkC35ezZSgvn8fhXEa9QTHSUtPfzQ";
      },
      {
        amount = 20_000;
        address = #p2pkh "mrFF91kpuRbivucowsY512fDnYt6BWrvx9";
      },
    ];
  },
  {
    // Insufficient funds.
    privateKey = "92Qba5hnyWSn5Ffcka56yMQauaWY6ZLd91Vzxbi4a9CCetaHtYj";
    signingNonces = [];
    expectedTxData = "";
    utxos = [
      {
        txid = "aabbccdd";
        vout = 2;
        value = 50_000;
      }
    ];
    destinations = [(#p2pkh "mgh4VjZx5MpkHRis9mDsF2ZcKLdXoP3oQ4", 50_000)];
    changeAddress = #p2pkh "mrFF91kpuRbivucowsY512fDnYt6BWrvx9";
    fees = 2_500;
    result = false;
    expectedInputs = [];
    expectedOutputs = [];
  },
  {
    // Insufficient funds.
    privateKey = "92Qba5hnyWSn5Ffcka56yMQauaWY6ZLd91Vzxbi4a9CCetaHtYj";
    signingNonces = [];
    expectedTxData = "";
    utxos = [
      {
        txid = "aabbccdd";
        vout = 1;
        value = 10_000;
      },
      {
        txid = "aabbccdd";
        vout = 2;
        value = 10_000;
      },
      {
        txid = "aabbccdd";
        vout = 3;
        value = 10_000;
      },
      {
        txid = "aabbccdd";
        vout = 4;
        value = 10_000;
      },
    ];
    destinations = [(#p2pkh "mgh4VjZx5MpkHRis9mDsF2ZcKLdXoP3oQ4", 40_000)];
    changeAddress = #p2pkh "mrFF91kpuRbivucowsY512fDnYt6BWrvx9";
    fees = 1;
    result = false;
    expectedInputs = [];
    expectedOutputs = [];
  },
  {
    // Handle bad destination address.
    privateKey = "92Qba5hnyWSn5Ffcka56yMQauaWY6ZLd91Vzxbi4a9CCetaHtYj";
    signingNonces = [];
    expectedTxData = "";
    utxos = [
      {
        txid = "aabbccdd";
        vout = 1;
        value = 10_000;
      }
    ];
    destinations = [(#p2pkh "jrFF91kpuRbivucowsY512fDnYt6BWrvx9", 15_000)];
    changeAddress = #p2pkh "mrFF91kpuRbivucowsY512fDnYt6BWrvx9";
    fees = 1_000;
    result = false;
    expectedInputs = [];
    expectedOutputs = [];
  },
  {
    // Handle bad change address.
    privateKey = "92Qba5hnyWSn5Ffcka56yMQauaWY6ZLd91Vzxbi4a9CCetaHtYj";
    signingNonces = [];
    expectedTxData = "";
    utxos = [
      {
        txid = "aabbccdd";
        vout = 1;
        value = 100_000;
      }
    ];
    destinations = [(#p2pkh "mgh4VjZx5MpkHRis9mDsF2ZcKLdXoP3oQ4", 15_000)];
    changeAddress = #p2pkh "jgh4VjZx5MpkHRis9mDsF2ZcKLdXoP3oQ4";
    fees = 1_000;
    result = false;
    expectedInputs = [];
    expectedOutputs = [];
  }
];

func testSignTransaction(testCase : SignTransactionTestCase) {
  let {privateKey;
       signingNonces;
       utxos;
       destinations;
       changeAddress;
       fees;
       result} = testCase;

  let mappedUtxos = Array.map<TestUtxo, Types.Utxo>(utxos, func (utxo) {
    switch (Hex.decode(utxo.txid)) {
      case (#ok txid) {
        {
          outpoint = {
            // Convert from RPC byte order to Internal byte order.
            txid = Blob.fromArray(Array.tabulate<Nat8>(txid.size(),
            func (n : Nat) {
              txid[txid.size() - 1 - n]
            }));
            vout = utxo.vout;
          };
          value = utxo.value;
          height = 0;
        }
      };
      case _ {
        Debug.trap("Failed to decode test case");
      };
    };
  });

  let expectedInputs = Array.map<TestTxInput, {txid : Blob; vout : Nat32}>(
    testCase.expectedInputs, func (expectedInput) {
      switch (Hex.decode(expectedInput.txid)) {
        case (#ok txid) {
          {
            // Convert from RPC byte order to Internal byte order.
            txid = Blob.fromArray(Array.tabulate<Nat8>(txid.size(),
            func (n : Nat) {
              txid[txid.size() - 1 - n]
            }));
            vout = expectedInput.vout;
          }
        };
        case _ {
          Debug.trap("Failed to decode test case");
        };
      };
    });

  let expectedOutputs = Array.map<TestTxOutput,
    {amount : Types.Satoshi; script : Script.Script}> (testCase.expectedOutputs,
    func (expectedOutput) {
      switch (Address.scriptPubKey(expectedOutput.address)) {
        case (#ok script) {
          {
            amount = expectedOutput.amount;
            script = script;
          }
        };
        case _ {
          Debug.trap("Failed to decode test case");
        };
      };
    });

  let ecdsaProxy = BitcoinTestTools.EcdsaProxy(
    testCase.privateKey, testCase.signingNonces);
  switch (
    Bitcoin.createSignedTransaction(
      #p2pkh (ecdsaProxy.p2pkhAddress()), ecdsaProxy, [],
      1, mappedUtxos, destinations, changeAddress, fees),
    result,
    Hex.decode(testCase.expectedTxData)
  ) {
    case (#ok tx, true, #ok data) {
      assert(tx.txInputs.size() == expectedInputs.size());
      for (i in Iter.range(0, expectedInputs.size() - 1)) {
        assert(tx.txInputs[i].prevOutput.txid == expectedInputs[i].txid);
        assert(tx.txInputs[i].prevOutput.vout == expectedInputs[i].vout);
      };
      assert(tx.txOutputs.size() == testCase.expectedOutputs.size());
      for (i in Iter.range(0, testCase.expectedOutputs.size() - 1)) {
        assert(tx.txOutputs[i].amount == testCase.expectedOutputs[i].amount);
        assert(tx.txOutputs[i].scriptPubKey == expectedOutputs[i].script);
      };

      let serialized = tx.toBytes();
      assert(serialized == data);
    };
    case (#err msg, false, _) {
      // Ok.
    };
    case _ {
      assert(false);
    };
  }
};

runTest({
  title = "Bitcoin sign transaction";
  fn = testSignTransaction;
  vectors = signTestCases;
});
