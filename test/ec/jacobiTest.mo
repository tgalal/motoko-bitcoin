import Debug "mo:base/Debug";
import Nat64 "mo:base/Nat64";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import TestUtils "../TestUtils";
import Common "../../src/Common";
import Secp256k1TestVectors "./Secp256k1TestVectors";
import WycheproofEcdhTestVectors "./wycheproofEcdhTestVectors";
import Curves "../../src/ec/Curves";
import Jacobi "../../src/ec/Jacobi";
import Hex "../Hex";
import P "mo:base/Prelude";

type DoublingVector = Secp256k1TestVectors.DoublingVector;
type MultiplicationVector = Secp256k1TestVectors.MultiplicationVector;
type BaseMultiplicationVector = Secp256k1TestVectors.BaseMultiplicationVector;
type SerializationVector = Secp256k1TestVectors.SerializationVector;
type AdditionVector = Secp256k1TestVectors.AdditionVector;
type WycheproofEcdhTestCase = WycheproofEcdhTestVectors.WycheproofEcdhTestCase;

let runTest = TestUtils.runTestWithDefaults;

func getSecp256k1Point(coords : ?(Nat, Nat)) : Jacobi.Point {
  return switch(coords) {
    case (?(x, y)) {
      switch(Jacobi.fromNat(x, y, 1, Curves.secp256k1)) {
        case (null) {
          P.unreachable();
        };
        case (?point) {
          point
        };
      };
    };
    case (null) {
      return #infinity (Curves.secp256k1);
    };
  };
};

func testAddition(vector: AdditionVector) {
  let inputPoint1 = getSecp256k1Point(vector.coords1);
  let inputPoint2 = getSecp256k1Point(vector.coords2);
  let expectedPoint = getSecp256k1Point(vector.output);
  let actual = Jacobi.add(inputPoint1, inputPoint2);
  assert(Jacobi.isEqual(expectedPoint, actual));
};

func testDoubling(vector : DoublingVector) {
  let inputPoint = getSecp256k1Point(vector.coords);
  let expectedPoint = getSecp256k1Point(vector.output);
  let actual = Jacobi.double(inputPoint);
  assert(Jacobi.isEqual(expectedPoint, actual));
};

func testMultiplication(vector : MultiplicationVector) {
  let inputPoint = getSecp256k1Point(vector.coords);
  let expectedPoint = getSecp256k1Point(vector.output);
  let actual = Jacobi.mul(inputPoint, vector.multiplicand);
  assert(Jacobi.isEqual(expectedPoint, actual));
};

func testBaseMultiplication(vector : BaseMultiplicationVector) {
  let expectedPoint = getSecp256k1Point(?vector.output);
  let actual = Jacobi.mulBase(vector.multiplicand, Curves.secp256k1);
  assert(Jacobi.isEqual(expectedPoint, actual));
};

func testSerializationUncompressed(vector : SerializationVector) {
  let inputPoint = getSecp256k1Point(vector.coords);
  let actual = Jacobi.toBytes(inputPoint, false);
  assert(vector.uncompressed == actual);
};

func testSerializationCompressed(vector : SerializationVector) {
  let inputPoint = getSecp256k1Point(vector.coords);
  let actual = Jacobi.toBytes(inputPoint, true);
  assert(vector.compressed == actual);
};

func testWycheproofEcdh(testCase : WycheproofEcdhTestCase) {
  var compressed : Bool = false;
  for (flag in testCase.flags.vals()) {
    if (flag == "CompressedPoint") {
      compressed := true;
    };
  };

  switch (
    Hex.decode(testCase.publicKey),
    Hex.decode(testCase.privateKey),
    Hex.decode(testCase.output)
  ) {
    case (#ok (encodedPublicKey), #ok (privateKeyBytes), #ok (outputBytes)) {
      // Simple ASN parsing just by extracting the public key from it.
      let publicKeySize = if (compressed) 33 else 65;
      if (encodedPublicKey.size() < 23 + publicKeySize) {
        assert(testCase.result == "invalid");
        return;
      };
      let publicKey = Array.tabulate<Nat8>(publicKeySize, func (i) {
        encodedPublicKey[encodedPublicKey.size() - publicKeySize  + i]
      });

      // Align private key to 32 bytes because conversion to Nat function
      // expects a 32-byte array.
      let alignedPrivateKey = Array.init<Nat8>(32, 0);
      for (i in Iter.range(0, Nat.min(privateKeyBytes.size() - 1, 31))) {
        alignedPrivateKey[alignedPrivateKey.size() - 1 - i] :=
          privateKeyBytes[privateKeyBytes.size() - 1 -i];
      };
      let privateKey : Nat = Common.readBE256(Array.freeze(alignedPrivateKey), 0);

      // Read expected output. It is sometimes empty.
      let expectedOutput : ?Nat = if (outputBytes.size() > 0) {
        ?(Common.readBE256(outputBytes, 0))
      } else {
        null
      };

      switch (Jacobi.fromBytes(publicKey, Curves.secp256k1), expectedOutput) {
        case (?(#point (point)), ?(expectedOutput)) {
          // Point is successfully decoded, compute ECDH.
          switch(Jacobi.toAffine(
            Jacobi.mul(#point point, privateKey))) {
            case (#point (x, y, _)) {
              // If we are here, then the test is expected to succeed.
              assert(testCase.result != "invalid");
              assert(expectedOutput == x.value);
            };
            case _ {
              Debug.trap("Test failed.");
            };
          };
        };
        case _ {
          // Point decoding is allowed to fail if the test case is not valid.
          if (testCase.result != "invalid") {
            Debug.trap("Could not decode point.");
          }
        };
      };
    };
    case _ {
      // Converting data from hex failed.
      Debug.trap("Could not decode test data.");
    };
  };
};

Debug.print("Jacobi Points over Secp256k1 Curve");

runTest({
  title = "Addition";
  fn = testAddition;
  vectors = Secp256k1TestVectors.additionVectors;
});

runTest({
  title = "Doubling";
  fn = testDoubling;
  vectors = Secp256k1TestVectors.doublingVectors;
});

runTest({
  title = "Multiplication";
  fn = testMultiplication;
  vectors = Secp256k1TestVectors.multiplicationVectors;
});

runTest({
  title = "Base Multiplication";
  fn = testBaseMultiplication;
  vectors = Secp256k1TestVectors.baseMultiplicationVectors;
});

runTest({
  title = "Compressed Serialization";
  fn = testSerializationCompressed;
  vectors = Secp256k1TestVectors.serializationVectors
});

runTest({
  title = "Uncompressed Serialization";
  fn = testSerializationUncompressed;
  vectors = Secp256k1TestVectors.serializationVectors
});

runTest({
  title = "Wycheproof ECDH";
  fn = testWycheproofEcdh;
  vectors = WycheproofEcdhTestVectors.testVectors;
});
