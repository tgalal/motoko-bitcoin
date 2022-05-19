import Segwit "../src/Segwit";
import Debug "mo:base/Debug";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Nat8 "mo:base/Nat8";
import Text "mo:base/Text";
import Char "mo:base/Char";

type ValidAddressTestCase = {
  address : Text;
  scriptPubKey : [Nat8];
};

type InvalidAddressEncodingTestCase = {
  hrp : Text;
  version : Nat8;
  programSize : Nat;
};

let validAddressTestCases : [ValidAddressTestCase] = [
  {
    address = "BC1QW508D6QEJXTDG4Y5R3ZARVARY0C5XW7KV8F3T4";
    scriptPubKey = [
      0x00, 0x14, 0x75, 0x1e, 0x76, 0xe8, 0x19, 0x91, 0x96, 0xd4, 0x54,
      0x94, 0x1c, 0x45, 0xd1, 0xb3, 0xa3, 0x23, 0xf1, 0x43, 0x3b, 0xd6
    ]
  },
  {
    address = "tb1qrp33g0q5c5txsp9arysrx4k6zdkfs4nce4xj0gdcccefvpysxf3q0sl5k7";
    scriptPubKey = [
        0x00, 0x20, 0x18, 0x63, 0x14, 0x3c, 0x14, 0xc5, 0x16, 0x68, 0x04,
        0xbd, 0x19, 0x20, 0x33, 0x56, 0xda, 0x13, 0x6c, 0x98, 0x56, 0x78,
        0xcd, 0x4d, 0x27, 0xa1, 0xb8, 0xc6, 0x32, 0x96, 0x04, 0x90, 0x32,
        0x62
    ]
  },
  {
    address = "bc1pw508d6qejxtdg4y5r3zarvary0c5xw7kw508d6qejxtdg4y5r3zarvary0c5xw7kt5nd6y";
    scriptPubKey = [
       0x51, 0x28, 0x75, 0x1e, 0x76, 0xe8, 0x19, 0x91, 0x96, 0xd4, 0x54,
       0x94, 0x1c, 0x45, 0xd1, 0xb3, 0xa3, 0x23, 0xf1, 0x43, 0x3b, 0xd6,
       0x75, 0x1e, 0x76, 0xe8, 0x19, 0x91, 0x96, 0xd4, 0x54, 0x94, 0x1c,
       0x45, 0xd1, 0xb3, 0xa3, 0x23, 0xf1, 0x43, 0x3b, 0xd6
    ]
  },
  {
    address = "BC1SW50QGDZ25J";
    scriptPubKey = [
      0x60, 0x02, 0x75, 0x1e
    ]
  },
  {
    address = "bc1zw508d6qejxtdg4y5r3zarvaryvaxxpcs";
    scriptPubKey = [
      0x52, 0x10, 0x75, 0x1e, 0x76, 0xe8, 0x19, 0x91, 0x96, 0xd4, 0x54,
      0x94, 0x1c, 0x45, 0xd1, 0xb3, 0xa3, 0x23
    ]
  },
  {
    address = "tb1qqqqqp399et2xygdj5xreqhjjvcmzhxw4aywxecjdzew6hylgvsesrxh6hy";
    scriptPubKey = [
      0x00, 0x20, 0x00, 0x00, 0x00, 0xc4, 0xa5, 0xca, 0xd4, 0x62, 0x21,
      0xb2, 0xa1, 0x87, 0x90, 0x5e, 0x52, 0x66, 0x36, 0x2b, 0x99, 0xd5,
      0xe9, 0x1c, 0x6c, 0xe2, 0x4d, 0x16, 0x5d, 0xab, 0x93, 0xe8, 0x64,
      0x33
    ]
  },
  {
    address = "tb1pqqqqp399et2xygdj5xreqhjjvcmzhxw4aywxecjdzew6hylgvsesf3hn0c";
    scriptPubKey = [
      0x51, 0x20, 0x00, 0x00, 0x00, 0xc4, 0xa5, 0xca, 0xd4, 0x62, 0x21,
      0xb2, 0xa1, 0x87, 0x90, 0x5e, 0x52, 0x66, 0x36, 0x2b, 0x99, 0xd5,
      0xe9, 0x1c, 0x6c, 0xe2, 0x4d, 0x16, 0x5d, 0xab, 0x93, 0xe8, 0x64,
      0x33
    ]
  },
  {
    address = "bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqzk5jj0";
    scriptPubKey = [
      0x51, 0x20, 0x79, 0xbe, 0x66, 0x7e, 0xf9, 0xdc, 0xbb, 0xac, 0x55,
      0xa0, 0x62, 0x95, 0xce, 0x87, 0x0b, 0x07, 0x02, 0x9b, 0xfc, 0xdb,
      0x2d, 0xce, 0x28, 0xd9, 0x59, 0xf2, 0x81, 0x5b, 0x16, 0xf8, 0x17,
      0x98
    ]
  }
];

let invalidAddressesTestCases = [
  // Invalid HRP.
  "tc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq5zuyut",
  // Invalid checksum algorithm (bech32 instead of bech32m).
  "bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqh2y7hd",
  // Invalid checksum algorithm (bech32 instead of bech32m).
  "tb1z0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqglt7rf",
  // Invalid checksum algorithm (bech32 instead of bech32m).
  "BC1S0XLXVLHEMJA6C4DQV22UAPCTQUPFHLXM9H8Z3K2E72Q4K9HCZ7VQ54WELL",
  // Invalid checksum algorithm (bech32m instead of bech32).
  "bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kemeawh",
  // Invalid checksum algorithm (bech32m instead of bech32).
  "tb1q0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq24jc47",
  // Invalid character in checksum.
  "bc1p38j9r5y49hruaue7wxjce0updqjuyyx0kh56v8s25huc6995vvpql3jow4",
  // Invalid witness version.
  "BC130XLXVLHEMJA6C4DQV22UAPCTQUPFHLXM9H8Z3K2E72Q4K9HCZ7VQ7ZWS8R",
  // Invalid program length (1 byte).
  "bc1pw5dgrnzv",
  // Invalid program length (41 bytes).
  "bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7v8n0nx0muaewav253zgeav",
  // Invalid program length for witness version 0 (per BIP141).
  "BC1QR508D6QEJXTDG4Y5R3ZARVARYV98GJ9P",
  // Mixed case.
  "tb1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq47Zagq",
  // More than 4 padding bits.
  "bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7v07qwwzcrf",
  // Non-zero padding in 8-to-5 conversion.
  "tb1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vpggkg4j",
  // Empty data section.
  "bc1gmk9yu",
];

let invalidAddressEncodingTestCases : [InvalidAddressEncodingTestCase] = [
  {
    hrp = "bc";
    version = 0;
    programSize = 21;
  },
  {
    hrp = "bc";
    version = 17;
    programSize = 32;
  },
  {
    hrp = "bc";
    version = 1;
    programSize = 1;
  },
  {
    hrp = "bc";
    version = 16;
    programSize = 41;
  },
];

func scriptPubKey({version; program} : Segwit.WitnessProgram) : [Nat8] {
  let output = Buffer.Buffer<Nat8>(program.size() + 2);
  if (version > 0) {
    output.add(version + 0x50);
  } else {
    output.add(0);
  };

  output.add(Nat8.fromIntWrap(program.size()));

  for (val in program.vals()) {
    output.add(val);
  };

  return output.toArray();
};

func toLower(text : Text) : Text {
  return Text.map(text, func (c) {
    if (c >= 'A' and c <= 'Z') {
      return Char.fromNat32(Char.toNat32(c) + 0x20);
    };
    return c;
  });
};

// Test whether valid addresses decode to the correct output.
func testValidAddress(testCase : ValidAddressTestCase) {
  var hrp = "bc";
  let witnessProgram = switch (Segwit.decode(hrp, testCase.address)) {
    case (#ok (witnessProgram)) {
      witnessProgram;
    };
    case (#err (_)) {
      hrp := "tb";
      switch (Segwit.decode(hrp, testCase.address)) {
        case (#ok (witnessProgram)) {
          witnessProgram
        };
        case (#err (msg)) {
          Debug.trap(msg);
        };
      };
    };
  };

  let actual = scriptPubKey(witnessProgram);
  assert(testCase.scriptPubKey == actual);

  switch (Segwit.encode(hrp, witnessProgram)) {
    case (#ok (recoded)) {
      assert(toLower(testCase.address) == toLower(recoded));
    };
    case (#err (msg)) {
      Debug.trap(msg);
    };
  };
};

// Test whether invalid addresses fail to decode.
func testInvalidAddress(testCase : Text) {
  var hrp = "bc";
  switch (Segwit.decode(hrp, testCase)) {
    case (#ok (witnessProgram)) {
      Debug.trap("First decode succeeded on invalid input: " # testCase);
    };
    case (#err (_)) {
      hrp := "tb";
      switch (Segwit.decode(hrp, testCase)) {
        case (#ok (_)) {
          Debug.trap("Second decode succeeded on invalid input: " # testCase);
        };
        case (#err (_)) {
          // Test passed..
        };
      };
    };
  };
};

// Test whether address encoding fails on invalid input.
func testInvalidAddressEncoding(testCase : InvalidAddressEncodingTestCase) {
  let program = Array.freeze(Array.init<Nat8>(testCase.programSize, 0));
  switch (Segwit.encode(testCase.hrp, {version = testCase.version; program})) {
    case (# ok (_)) {
      Debug.trap("Encode succeeds on invalid input.");
    };
    case _ {
      // Test passed.
    };
  };
};

Debug.print("Segwit Addresses");
do {
  for (i in Iter.range(0, validAddressTestCases.size() - 1)) {
    testValidAddress(validAddressTestCases[i]);
  };
  for (i in Iter.range(0, invalidAddressesTestCases.size() - 1)) {
    testInvalidAddress(invalidAddressesTestCases[i]);
  };
  for (i in Iter.range(0, invalidAddressEncodingTestCases.size() - 1)) {
    testInvalidAddressEncoding(invalidAddressEncodingTestCases[i]);
  };
};
