import Debug "mo:base/Debug";
import TestUtils "../TestUtils";
import Secp256k1TestVectors "./Secp256k1TestVectors";
import Curves "../../src/ec/Curves";
import Jacobi "../../src/ec/Jacobi";
import P "mo:base/Prelude";

type DoublingVector = Secp256k1TestVectors.DoublingVector;
type MultiplicationVector = Secp256k1TestVectors.MultiplicationVector;
type BaseMultiplicationVector = Secp256k1TestVectors.BaseMultiplicationVector;
type SerializationVector = Secp256k1TestVectors.SerializationVector;
type AdditionVector = Secp256k1TestVectors.AdditionVector;

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
      return #infinity;
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
