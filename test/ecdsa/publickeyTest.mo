import PublicKey "../../src/ecdsa/Publickey";
import Curves "../../src/ec/Curves";
import Affine "../../src/ec/Affine";
import TestUtils "../TestUtils";

type PublicKeyFromBytesTestCase = {
  data : [Nat8];
  valid : Bool;
};

type PublicKeyFromPointTestCase = {
  coords : ?(Nat, Nat);
  valid : Bool;
};

let publicKeyFromPointTestCases : [PublicKeyFromPointTestCase] =  [
  {
    // Will be treated as infinity;
    coords = null;
    valid = false;
  },
  {
    coords = ?(0, 12);
    valid = false;
  },
  {
    coords = ?(
      0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798,
      0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8,
    );
    valid = true;
  }
];

let publicKeyFromBytesTestCases : [PublicKeyFromBytesTestCase] = [
  {
    data = [];
    valid = false;
  },
  {
    data = [0];
    valid = false;
  },
  {
    data = [
      0x03, 0x9a, 0xc8, 0xba, 0xc8, 0xf6, 0xd9, 0x16, 0xb8, 0xa8, 0x5b, 0x45,
      0x8e, 0x08, 0x7e, 0x0c, 0xd0, 0x7e, 0x6a, 0x76, 0xa6, 0xbf, 0xdd, 0xe9,
      0xbb, 0x76, 0x6b, 0x17, 0x08, 0x6d, 0x9a, 0x5c, 0x8a
    ];
    valid = true;
  },
  {
    // Bad uncompressed form.
    data = [
      0x04, 0x9a, 0xc8, 0xba, 0xc8, 0xf6, 0xd9, 0x16, 0xb8, 0xa8, 0x5b, 0x45,
      0x8e, 0x08, 0x7e, 0x0c, 0xd0, 0x7e, 0x6a, 0x76, 0xa6, 0xbf, 0xdd, 0xe9,
      0xbb, 0x76, 0x6b, 0x17, 0x08, 0x6d, 0x9a, 0x5c, 0x8a
    ];
    valid = false;
  },
  {
    // Invalid type: 0x08.
    data = [
      0x08, 0x9a, 0xc8, 0xba, 0xc8, 0xf6, 0xd9, 0x16, 0xb8, 0xa8, 0x5b, 0x45,
      0x8e, 0x08, 0x7e, 0x0c, 0xd0, 0x7e, 0x6a, 0x76, 0xa6, 0xbf, 0xdd, 0xe9,
      0xbb, 0x76, 0x6b, 0x17, 0x08, 0x6d, 0x9a, 0x5c, 0x8a
    ];
    valid = false;
  }
];

func testPublicKeyFromBytes(testCase : PublicKeyFromBytesTestCase) {
  switch(PublicKey.decode(#sec1 (testCase.data, Curves.secp256k1))) {
    case (#ok(pk)) {
      assert(testCase.valid);
    };
    case _ {
      assert(not testCase.valid);
    };
  };
};

func testPublicKeyFromPoint(testCase : PublicKeyFromPointTestCase) {
  let curve = Curves.secp256k1;
  let point : Affine.Point = switch (testCase.coords) {
    case (null) {
      #infinity(curve)
    };
    case (?(x, y)) {
     #point (curve.Fp(x), curve.Fp(y), curve)
    };
  };
  switch(PublicKey.decode(#point (point))) {
    case (#ok(pk)) {
      assert(testCase.valid);
    };
    case _ {
      assert(not testCase.valid);
    };
  };
};

let runTest = TestUtils.runTestWithDefaults;

runTest({
  title = "PublicKey from bytes.";
  fn = testPublicKeyFromBytes;
  vectors = publicKeyFromBytesTestCases;
});

runTest({
  title = "PublicKey from point.";
  fn = testPublicKeyFromPoint;
  vectors = publicKeyFromPointTestCases;
});
