import Iter "mo:base/Iter";
import Debug "mo:base/Debug";
import Array "mo:base/Array";
import Common "../src/Common";

let testData : [{
  offset : Nat;
  nat32 : Nat32;
  nat64: Nat64;
  nat128: Nat;
  nat256: Nat;
  big32: [Nat8];
  big64: [Nat8];
  big128: [Nat8];
  big256: [Nat8];
}] =
[
  {
    offset = 0;
    nat32 = 0xad5efbc6;
    nat64 = 0xad5efbc62010894e;
    nat128 = 0xad5efbc62010894e5219f2709fa5a100;
    nat256 = 0xad5efbc62010894e5219f2709fa5a1007b51fdf370c1f00cc0ee0425e41dd5cd;
    big32 = [ 0xad, 0x5e, 0xfb, 0xc6 ];
    big64 = [ 0xad, 0x5e, 0xfb, 0xc6, 0x20, 0x10, 0x89, 0x4e ];
    big128 = [
      0xad, 0x5e, 0xfb, 0xc6, 0x20, 0x10, 0x89, 0x4e,
      0x52, 0x19, 0xf2, 0x70, 0x9f, 0xa5, 0xa1, 0x00
    ];
    big256 = [
      0xad, 0x5e, 0xfb, 0xc6, 0x20, 0x10, 0x89, 0x4e,
      0x52, 0x19, 0xf2, 0x70, 0x9f, 0xa5, 0xa1, 0x00,
      0x7b, 0x51, 0xfd, 0xf3, 0x70, 0xc1, 0xf0, 0x0c,
      0xc0, 0xee, 0x04, 0x25, 0xe4, 0x1d, 0xd5, 0xcd,
    ];
  },{
    offset = 1;
    nat32 = 0x5efbc620;
    nat64 =  0x5efbc62010894e52;
    nat128 = 0x5efbc62010894e5219f2709fa5a1007b;
    nat256 = 0x5efbc62010894e5219f2709fa5a1007b51fdf370c1f00cc0ee0425e41dd5cd9c;
    big32 = [ 0xad, 0x5e, 0xfb, 0xc6, 0x20];
    big64 = [ 0xad, 0x5e, 0xfb, 0xc6, 0x20, 0x10, 0x89, 0x4e, 0x52];
    big128 = [
      0xad, 0x5e, 0xfb, 0xc6, 0x20, 0x10, 0x89, 0x4e,
      0x52, 0x19, 0xf2, 0x70, 0x9f, 0xa5, 0xa1, 0x00,
      0x7b
    ];
    big256 = [
      0xad, 0x5e, 0xfb, 0xc6, 0x20, 0x10, 0x89, 0x4e,
      0x52, 0x19, 0xf2, 0x70, 0x9f, 0xa5, 0xa1, 0x00,
      0x7b, 0x51, 0xfd, 0xf3, 0x70, 0xc1, 0xf0, 0x0c,
      0xc0, 0xee, 0x04, 0x25, 0xe4, 0x1d, 0xd5, 0xcd,
      0x9c
    ];
  }
];

Debug.print("Common");

do {
  for (i in Iter.range(0, testData.size() - 1)) {
    let currentData = testData[i];
    let offset = currentData.offset;

    do {
      Debug.print("  readBE32");
      let expected = currentData.nat32;
      let actual = Common.readBE32(currentData.big32, offset);
      assert(expected == actual);
    };

    do {
      Debug.print("  readBE64");
      let expected = currentData.nat64;
      let actual = Common.readBE64(currentData.big64, offset);
      assert(expected == actual);
    };

    do {
      Debug.print("  readBE128");
      let expected = currentData.nat128;
      let actual = Common.readBE128(currentData.big128, offset);
      assert(expected == actual);
    };

    do {
      Debug.print("  readBE256");
      let expected = currentData.nat256;
      let actual = Common.readBE256(currentData.big256, offset);
      assert(expected == actual);
    };

    do {
      Debug.print("  writeBE32");

      let output = Array.init<Nat8>(4, 0);
      let expected = Array.tabulate<Nat8>(4, func (i) {
        return currentData.big32[offset + i];
      });
      Common.writeBE32(output, 0, currentData.nat32);
    };

    do {
      Debug.print("  writeBE64");

      let output = Array.init<Nat8>(8, 0);
      let expected = Array.tabulate<Nat8>(8, func (i) {
        return currentData.big64[offset + i];
      });
      Common.writeBE64(output, 0, currentData.nat64);
    };

    do {
      Debug.print("  writeBE128");

      let output = Array.init<Nat8>(16, 0);
      let expected = Array.tabulate<Nat8>(16, func (i) {
        return currentData.big128[offset + i];
      });
      Common.writeBE128(output, 0, currentData.nat128);
    };

    do {
      Debug.print("  writeBE256");

      let output = Array.init<Nat8>(32, 0);
      let expected = Array.tabulate<Nat8>(32, func (i) {
        return currentData.big256[offset + i];
      });
      Common.writeBE256(output, 0, currentData.nat256);
    };
  };
};

do {
  Debug.print("  Text to Nat");
  let testData : [(Text, ?Nat)] = [
    ("0", ?0),
    ("1", ?1),
    ("2", ?2),
    ("12345", ?12345),
    ("55555", ?55555),
    ("299999999", ?299999999),
    ("0xff", null),
    ("  ", null),
    ("  l", null),
    ("1  l", null),
    ("1  ", null),
    ("abc", null),
    ("1abc", null),
    ("abc1", null),
    ("/5", null),
    ("5/", null),
    (":5", null),
    ("5:", null),
  ];

  for ((input, output) in testData.vals()) {
    let actual = Common.textToNat(input);
    assert(actual == output);
  };
};
