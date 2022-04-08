import Debug "mo:base/Debug";
import Field "../../src/ec/Field";
import TestUtils "../TestUtils";

type InverseTestVector = {
  input : Nat;
  modulus : Nat;
  output : ?Nat;
};

type AdditionTestVector = {
  input1 : Nat;
  input2 : Nat;
  modulus : Nat;
  output : Nat;
};

type MultiplicationTestVector = {
  input1 : Nat;
  input2 : Nat;
  modulus : Nat;
  output : Nat;
};

type ExponentiationTestVector = {
  inputBase : Nat;
  inputExponent : Nat;
  modulus : Nat;
  output : Nat;
};

type NegationTestVector = {
  input : Nat;
  modulus : Nat;
  output : Nat;
};

let negationTestVectors : [NegationTestVector] = [
  {
    input = 2;
    modulus = 10;
    output = 8;
  },
  {
    input =
      0x5e1b5a85ee96363e1c867c4365a1cd3acf2f811d00a0ba09e7f0018ac1bb938b;
    modulus = 
      0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f;
    output =
      0xa1e4a57a1169c9c1e37983bc9a5e32c530d07ee2ff5f45f6180ffe743e4468a4;
  },
];

let inverseTestVectors : [InverseTestVector] = [
  {
    input = 2;
    modulus = 10;
    output = null;
  },
  {
    input =
      0x5e1b5a85ee96363e1c867c4365a1cd3acf2f811d00a0ba09e7f0018ac1bb938b;
    modulus =
      0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f;
    output =
      ?0xc17e859f560b71dbfe25376e301882bac339578e3449d308051316cbd01896fa;
  },
];

let additionTestVectors : [AdditionTestVector] = [
  {
    input1 = 2;
    input2 = 0;
    modulus = 10;
    output = 2;
  },
  {
    input1 = 2;
    input2 = 2;
    modulus = 10;
    output = 4;
  },
  {
    input1 =
      0x5e1b5a85ee96363e1c867c4365a1cd3acf2f811d00a0ba09e7f0018ac1bb938b;
    input2 = 0;
    modulus =
      0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f;
    output =
      0x5e1b5a85ee96363e1c867c4365a1cd3acf2f811d00a0ba09e7f0018ac1bb938b;
  },
  {
    input1 =
      0x5e1b5a85ee96363e1c867c4365a1cd3acf2f811d00a0ba09e7f0018ac1bb938b;
    input2 =
      0x5e1b5a85ee96363e1c867c4365a1cd3acf2f811d00a0ba09e7f0018ac1bb938b;
    modulus =
      0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f;
    output =
      0xbc36b50bdd2c6c7c390cf886cb439a759e5f023a01417413cfe0031583772716;
  },
  {
    input1 =
      0x5e1b5a85ee96363e1c867c4365a1cd3acf2f811d00a0ba09e7f0018ac1bb938b;
    input2 =
      0xb05475918be6fca0b33578cc116a4f6d83384f5c1f64765770cb2d65e62fa721;
    modulus =
      0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f;
    output =
      0xe6fd0177a7d32decfbbf50f770c1ca85267d0792005306158bb2ef1a7eb3e7d;
  },
];

let multiplicationTestVectors : [MultiplicationTestVector] = [
  {
    input1 = 2;
    input2 = 1;
    modulus = 10;
    output = 2;
  },
  {
    input1 = 2;
    input2 = 6;
    modulus = 10;
    output = 2;
  },
  {
    input1 = 2;
    input2 = 7;
    modulus = 10;
    output = 4;
  },
  {
    input1 = 2;
    input2 = 8;
    modulus = 10;
    output = 6;
  },
  {
    input1 =
      0x5e1b5a85ee96363e1c867c4365a1cd3acf2f811d00a0ba09e7f0018ac1bb938b;
    input2 =
      0x7428ee4bc98bdeae9edad9c2ee42c1f41df0c02737bdcff7854503f96ec0aca3;
    modulus =
      0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f;
    output =
      0x7525448920a2ce40b12e57a6e6a4c807f94c40515ef60f67dd534ec0762f8199;
  },
  {
    input1 =
      0x5e1b5a85ee96363e1c867c4365a1cd3acf2f811d00a0ba09e7f0018ac1bb938b;
    input2 =
      0x2341d42d819752a72103b5a7aaa4e5566010e04d53d16a229154be07b49a7c1b;
    modulus =
      0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f;
    output =
      0x2b53bd63f19ce54da921c37760553be2cbacff9fe8b4898eef19f34caa5f87a7;
  },
  {
    input1 =
      0x5e1b5a85ee96363e1c867c4365a1cd3acf2f811d00a0ba09e7f0018ac1bb938b;
    input2 =
      0x3fda9f79ba925d04605392760613c46924dd905ee92568bccad310dedeb14e1;
    modulus =
      0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f;
    output =
      0x700cc9865e33a6b36ffc1f89c6df2c98570662bef5ecc0259ff0ab648c940077;
  },
  {
    input1 =
      0x5e1b5a85ee96363e1c867c4365a1cd3acf2f811d00a0ba09e7f0018ac1bb938b;
    input2 =
      0x160f15294cf25d3f05081da5bcf23d4b09e7b5598122ad46f12840a71df89ff3;
    modulus =
      0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f;
    output =
      0x8f417929351384ca9ff38674e4773208a634b630ba4fe81306b339800550aa21;
  },
];

let expentiationTestVectors : [ExponentiationTestVector] = [
  {
    inputBase = 2;
    inputExponent = 0;
    modulus = 10;
    output = 1;
  },
  {
    inputBase = 2;
    inputExponent = 1;
    modulus = 10;
    output = 2;
  },
  {
    inputBase = 2;
    inputExponent = 2;
    modulus = 10;
    output = 4;
  },
  {
    inputBase = 2;
    inputExponent = 5;
    modulus = 10;
    output = 2;
  },
  {
    inputBase = 
        0x5e1b5a85ee96363e1c867c4365a1cd3acf2f811d00a0ba09e7f0018ac1bb938b;
    inputExponent = 
        0;
    modulus = 
        0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f;
    output = 1;
  },
  {
    inputBase = 
        0x5e1b5a85ee96363e1c867c4365a1cd3acf2f811d00a0ba09e7f0018ac1bb938b;
    inputExponent = 
        1;
    modulus = 
        0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f;
    output =
        0x5e1b5a85ee96363e1c867c4365a1cd3acf2f811d00a0ba09e7f0018ac1bb938b;
  },
  {
    inputBase = 
        0x5e1b5a85ee96363e1c867c4365a1cd3acf2f811d00a0ba09e7f0018ac1bb938b;
    inputExponent = 
        0xa1075f893b6a8db868e1d98e85fadab0609bc17ba3e46e1898e63b783d48cabb;
    modulus = 
        0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f;
    output =
        0x787b95274dc91d032ecd91aa339275cbdefc39e99c3da9fd1eaceae9c915eb57;
  },
];

func testAddition(vector : AdditionTestVector) {
  var actual = Field.add(vector.input1, vector.input2, vector.modulus);
  assert(vector.output == actual);

  // commutativity
  actual := Field.add(vector.input2, vector.input1, vector.modulus);
  assert(vector.output == actual);
};

func testSubtraction(vector : AdditionTestVector) {
  var actual = Field.sub(vector.output, vector.input1, vector.modulus);

  assert(vector.input2 == actual);

  actual := Field.sub(vector.output, vector.input2, vector.modulus);
  assert(vector.input1 == actual);
};

func testExponentiation(vector : ExponentiationTestVector) {
  let actual = Field.pow(vector.inputBase, vector.inputExponent,
    vector.modulus);
  assert(vector.output == actual);
};

func testMultiplication(vector : MultiplicationTestVector) {
  var actual = Field.mul(vector.input1, vector.input2, vector.modulus);
  assert(vector.output == actual);

  // commutativity
  actual := Field.mul(vector.input2, vector.input1, vector.modulus);
  assert(vector.output == actual);
};

func testInverse(vector : InverseTestVector) {
  let actual = Field.inverse(vector.input, vector.modulus);
  assert(vector.output == actual);
};

func testNegation(vector : NegationTestVector) {
  let actual = Field.neg(vector.input, vector.modulus);
  assert(vector.output == actual);
};

let runTest = TestUtils.runTestWithDefaults;

Debug.print("Test Field");

runTest({
  title = "Addition";
  fn = testAddition;
  vectors = additionTestVectors;
});

runTest({
  title = "Subtraction";
  fn = testSubtraction;
  vectors = additionTestVectors;
});

runTest({
  title = "Multiplication";
  fn = testMultiplication;
  vectors = multiplicationTestVectors;
});

runTest({
  title = "Exponentiation";
  fn = testExponentiation;
  vectors = expentiationTestVectors;
});

runTest({
  title = "Inverse";
  fn = testInverse;
  vectors = inverseTestVectors;
});

runTest({
  title = "Negation";
  fn = testNegation;
  vectors = negationTestVectors;
});
