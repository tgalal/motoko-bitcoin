import Numbers "../../src/ec/Numbers";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import TestUtils "../TestUtils";

type EeaTestVector = {
  input : (Int, Int);
  expected : (Int, Int, Int);
};

type ToBinaryTestVector = {
  input : Nat;
  expected : [Bool];
};

type ToNafTestVector = {
  input : Int;
  expected : [Int];
};

let eeaTestVectors : [EeaTestVector] = [
  {
    input = (20, 5);
    expected = (5, 0, 1);
  },
  {
    input = (1, 1);
    expected = (1, 0, 1);
  },
  {
    input = (0, 1);
    expected = (1, 0, 1);
  },
  {
    input = (1, 0);
    expected = (1, 1, 0);
  },
  {
    input = (0, 0);
    expected = (0, 1, 0);
  },
  {
    input = (1559800762, 3328432062);
    expected = (2, -423540526, 198483497);
  },
  {
    input = (2812401886, 3365887753);
    expected = (1, -269488733, 225174063);
  },
  {
    input = (4022921583, 839253427);
    expected = (1, 386378290, -1852086047);
  },
  {
    input = (1677363057, 2087277929);
    expected = (1, -16259906, 13066667);
  },
  {
    input = (3259378921, 2551224643);
    expected = (1, -285162661, 364316474);
  },
];

func testEea({input; expected} : EeaTestVector) {
  let actual = Numbers.eea(input.0, input.1);
  assert(expected == actual);
};

let toBinaryTestVectors : [ToBinaryTestVector] = [
  {
    input = 0x0;
    expected = [];
  },
  {
    input = 0x1;
    expected = [true];
  },
  {
    input = 0x2;
    expected = [true, false];
  },
  {
    input = 0x3;
    expected = [true, true];
  },
  {
    input = 0xfe;
    expected = [true, true, true, true, true, true, true, false];
  },
  {
    input = 0xff;
    expected = [true, true, true, true, true, true, true, true];
  },
  {
    input = 0x100;
    expected = [true, false, false, false, false, false, false, false, false];
  },
  {
    input = 0x1e545442;
    expected = [
      true, true, true, true, false, false, true, false, true, false, true,
      false, false, false, true, false, true, false, true, false, false, false,
      true, false, false, false, false, true, false
    ];
  },
  {
    input = 0xe91c2b8e;
    expected = [
      true, true, true, false, true, false, false, true, false, false, false,
      true, true, true, false, false, false, false, true, false, true, false,
      true, true, true, false, false, false, true, true, true, false
    ];
  },
  {
    input = 0x7560804a;
    expected = [
      true, true, true, false, true, false, true, false, true, true, false,
      false, false, false, false, true, false, false, false, false, false, false,
      false, false, true, false, false, true, false, true, false
    ];
  },
  {
    input = 0xf9859ac1;
    expected = [
      true, true, true, true, true, false, false, true, true, false, false,
      false, false, true, false, true, true, false, false, true, true, false,
      true, false, true, true, false, false, false, false, false, true
    ];
  },
  {
    input = 0x10471430;
    expected = [
      true, false, false, false, false, false, true, false, false, false, true,
      true, true, false, false, false, true, false, true, false, false, false,
      false, true, true, false, false, false, false
    ];
  },
];
func testToBinary({input; expected}: ToBinaryTestVector) {
  let actual = Numbers.toBinary(input);
  assert(expected == actual);
};

let toNafTestVectors : [ToNafTestVector] = [
  {
    input = 59349;
    expected = [1, 0, 1, 0, 1, 0, -1, 0, 0, 0, 0, 1, 0, -1, 0, 0, 1];
  },
  {
    input = 29131;
    expected = [-1, 0, -1, 0, 1, 0, -1, 0, 0, 1, 0, 0, -1, 0, 0, 1];
  },
  {
    input = 22494;
    expected = [0, -1, 0, 0, 0, -1, 0, 0, 0, 0, 0, -1, 0, -1, 0, 1];
  },
  {
    input = 32310;
    expected = [0, -1, 0, -1, 0, 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1];
  },
  {
    input = 44797;
    expected = [1, 0, -1, 0, 0, 0, 0, 0, -1, 0, 0, 0, -1, 0, -1, 0, 1];
  },
];
func testToNaf({input; expected} : ToNafTestVector) {
  let actual = Numbers.toNaf(input);
  assert(expected == actual);
};

Debug.print("Numbers Test");

let runTest = TestUtils.runTestWithDefaults;

runTest({
  title = "Extended Euclidean Algorithm";
  fn = testEea;
  vectors = eeaTestVectors;
});

runTest({
  title = "Convert Decimal to Binary";
  fn = testToBinary;
  vectors = toBinaryTestVectors;
});

runTest({
  title = "Non-adjacent form representation";
  fn = testToNaf;
  vectors = toNafTestVectors;
});
