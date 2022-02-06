import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Nat64 "mo:base/Nat64";
import Common "./Common";

module {
  // Hash the given array and return finalized result.
  public func hash(array : [Nat8]) : [Nat8] {
    let digest = Digest();
    digest.write(array);
    return digest.sum();
  };

  public class Digest() {
    private let s : [var Nat32] = Array.init<Nat32>(5, 0);
    private let buf : [var Nat8] = Array.init<Nat8>(64, 0);
    private var bytes : Nat64 = 0;

    private func initialize() {
      s[0] := 0x67452301;
      s[1] := 0xEFCDAB89;
      s[2] := 0x98BADCFE;
      s[3] := 0x10325476;
      s[4] := 0xC3D2E1F0;
    };

    initialize();

    public func reset() {
      bytes := 0;
      initialize();
    };

    private func f1(x : Nat32, y : Nat32, z : Nat32) : Nat32 {
      x ^ y ^ z;
    };

    private func f2(x : Nat32, y : Nat32, z : Nat32) : Nat32 {
      (x & y) | (^x & z);
    };

    private func f3(x : Nat32, y : Nat32, z : Nat32) : Nat32 {
      (x | ^y) ^ z;
    };

    private func f4(x : Nat32, y : Nat32, z : Nat32) : Nat32 {
      (x & z) | (y & ^z);
    };

    private func f5(x : Nat32, y : Nat32, z : Nat32) : Nat32 {
      x ^ (y | ^z);
    };

    private func rol(x : Nat32, i : Nat32) : Nat32 {
      (x << i) | (x >> (32 - i));
    };

    private func round(
      a : Nat32,
      b : Nat32,
      c : Nat32,
      d : Nat32,
      e : Nat32,
      f : Nat32,
      x : Nat32,
      k : Nat32,
      r : Nat32
    ): (Nat32, Nat32) {
      (rol(a +% f +% x +% k, r) +% e, rol(c, 10));
    };

    private func r11(
      a : Nat32,
      b : Nat32,
      c : Nat32,
      d : Nat32,
      e : Nat32,
      x : Nat32,
      r : Nat32
    ) : (Nat32, Nat32) {
      round(a, b, c, d, e, f1(b, c, d), x, 0, r);
    };

    private func r21(
      a : Nat32,
      b : Nat32,
      c : Nat32,
      d : Nat32,
      e : Nat32,
      x : Nat32,
      r : Nat32
    ) : (Nat32, Nat32) {
      round(a, b, c, d, e, f2(b, c, d), x, 0x5A827999, r);
    };

    private func r31(
      a : Nat32,
      b : Nat32,
      c : Nat32,
      d : Nat32,
      e : Nat32,
      x : Nat32,
      r : Nat32
    ) : (Nat32, Nat32) {
      round(a, b, c, d, e, f3(b, c, d), x, 0x6ED9EBA1, r);
    };

    private func r41(
      a : Nat32,
      b : Nat32,
      c : Nat32,
      d : Nat32,
      e : Nat32,
      x : Nat32,
      r : Nat32
    ) : (Nat32, Nat32) {
      round(a, b, c, d, e, f4(b, c, d), x, 0x8F1BBCDC, r);
    };

    private func r51(
      a : Nat32,
      b : Nat32,
      c : Nat32,
      d : Nat32,
      e : Nat32,
      x : Nat32,
      r : Nat32
    ) : (Nat32, Nat32) {
      round(a, b, c, d, e, f5(b, c, d), x, 0xA953FD4E, r);
    };

    private func r12(
      a : Nat32,
      b : Nat32,
      c : Nat32,
      d : Nat32,
      e : Nat32,
      x : Nat32,
      r : Nat32
    ) : (Nat32, Nat32) {
      round(a, b, c, d, e, f5(b, c, d), x, 0x50A28BE6, r);
    };

    private func r22(
      a : Nat32,
      b : Nat32,
      c : Nat32,
      d : Nat32,
      e : Nat32,
      x : Nat32,
      r : Nat32
    ) : (Nat32, Nat32) {
      round(a, b, c, d, e, f4(b, c, d), x, 0x5C4DD124, r);
    };

    private func r32(
      a : Nat32,
      b : Nat32,
      c : Nat32,
      d : Nat32,
      e : Nat32,
      x : Nat32,
      r : Nat32
    ) : (Nat32, Nat32) {
      round(a, b, c, d, e, f3(b, c, d), x, 0x6D703EF3, r);
    };

    private func r42(
      a : Nat32,
      b : Nat32,
      c : Nat32,
      d : Nat32,
      e : Nat32,
      x : Nat32,
      r : Nat32
    ) : (Nat32, Nat32) {
      round(a, b, c, d, e, f2(b, c, d), x, 0x7A6D76E9, r);
    };

    private func r52(
      a : Nat32,
      b : Nat32,
      c : Nat32,
      d : Nat32,
      e : Nat32,
      x : Nat32,
      r : Nat32
    ) : (Nat32, Nat32) {
      round(a, b, c, d, e, f1(b, c, d), x, 0, r);
    };

    // Perform a RIPEMD-160 transformation, processing a 64-byte chunk.
    private func transform(chunk : [Nat8], offset : Nat) {
      var a1 : Nat32 = s[0];
      var b1 : Nat32 = s[1];
      var c1 : Nat32 = s[2];
      var d1 : Nat32 = s[3];
      var e1 : Nat32 = s[4];
      var a2 : Nat32 = a1;
      var b2 : Nat32 = b1;
      var c2 : Nat32 = c1;
      var d2 : Nat32 = d1;
      var e2 : Nat32 = e1;
      let w0 : Nat32 = Common.readLE32(chunk, offset);
      let w1 : Nat32 = Common.readLE32(chunk, offset + 4);
      let w2 : Nat32 = Common.readLE32(chunk, offset + 8);
      let w3 : Nat32 = Common.readLE32(chunk, offset + 12);
      let w4 : Nat32 = Common.readLE32(chunk, offset + 16);
      let w5 : Nat32 = Common.readLE32(chunk, offset + 20);
      let w6 : Nat32 = Common.readLE32(chunk, offset + 24);
      let w7 : Nat32 = Common.readLE32(chunk, offset + 28);
      let w8 : Nat32 = Common.readLE32(chunk, offset + 32);
      let w9 : Nat32 = Common.readLE32(chunk, offset + 36);
      let w10 : Nat32 = Common.readLE32(chunk, offset + 40);
      let w11 : Nat32 = Common.readLE32(chunk, offset + 44);
      let w12 : Nat32 = Common.readLE32(chunk, offset + 48);
      let w13 : Nat32 = Common.readLE32(chunk, offset + 52);
      let w14 : Nat32 = Common.readLE32(chunk, offset + 56);
      let w15 : Nat32 = Common.readLE32(chunk, offset + 60);

      var temp : (Nat32, Nat32) = r11(a1, b1, c1, d1, e1, w0, 11);
      a1 := temp.0; c1 := temp.1;
      temp := r12(a2, b2, c2, d2, e2, w5, 8);
      a2 := temp.0; c2 := temp.1;
      temp := r11(e1, a1, b1, c1, d1, w1, 14);
      e1 := temp.0; b1 := temp.1;
      temp := r12(e2, a2, b2, c2, d2, w14, 9);
      e2 := temp.0; b2 := temp.1;
      temp := r11(d1, e1, a1, b1, c1, w2, 15);
      d1 := temp.0; a1 := temp.1;
      temp := r12(d2, e2, a2, b2, c2, w7, 9);
      d2 := temp.0; a2 := temp.1;
      temp := r11(c1, d1, e1, a1, b1, w3, 12);
      c1 := temp.0; e1 := temp.1;
      temp := r12(c2, d2, e2, a2, b2, w0, 11);
      c2 := temp.0; e2 := temp.1;
      temp := r11(b1, c1, d1, e1, a1, w4, 5);
      b1 := temp.0; d1 := temp.1;
      temp := r12(b2, c2, d2, e2, a2, w9, 13);
      b2 := temp.0; d2 := temp.1;
      temp := r11(a1, b1, c1, d1, e1, w5, 8);
      a1 := temp.0; c1 := temp.1;
      temp := r12(a2, b2, c2, d2, e2, w2, 15);
      a2 := temp.0; c2 := temp.1;
      temp := r11(e1, a1, b1, c1, d1, w6, 7);
      e1 := temp.0; b1 := temp.1;
      temp := r12(e2, a2, b2, c2, d2, w11, 15);
      e2 := temp.0; b2 := temp.1;
      temp := r11(d1, e1, a1, b1, c1, w7, 9);
      d1 := temp.0; a1 := temp.1;
      temp := r12(d2, e2, a2, b2, c2, w4, 5);
      d2 := temp.0; a2 := temp.1;
      temp := r11(c1, d1, e1, a1, b1, w8, 11);
      c1 := temp.0; e1 := temp.1;
      temp := r12(c2, d2, e2, a2, b2, w13, 7);
      c2 := temp.0; e2 := temp.1;
      temp := r11(b1, c1, d1, e1, a1, w9, 13);
      b1 := temp.0; d1 := temp.1;
      temp := r12(b2, c2, d2, e2, a2, w6, 7);
      b2 := temp.0; d2 := temp.1;
      temp := r11(a1, b1, c1, d1, e1, w10, 14);
      a1 := temp.0; c1 := temp.1;
      temp := r12(a2, b2, c2, d2, e2, w15, 8);
      a2 := temp.0; c2 := temp.1;
      temp := r11(e1, a1, b1, c1, d1, w11, 15);
      e1 := temp.0; b1 := temp.1;
      temp := r12(e2, a2, b2, c2, d2, w8, 11);
      e2 := temp.0; b2 := temp.1;
      temp := r11(d1, e1, a1, b1, c1, w12, 6);
      d1 := temp.0; a1 := temp.1;
      temp := r12(d2, e2, a2, b2, c2, w1, 14);
      d2 := temp.0; a2 := temp.1;
      temp := r11(c1, d1, e1, a1, b1, w13, 7);
      c1 := temp.0; e1 := temp.1;
      temp := r12(c2, d2, e2, a2, b2, w10, 14);
      c2 := temp.0; e2 := temp.1;
      temp := r11(b1, c1, d1, e1, a1, w14, 9);
      b1 := temp.0; d1 := temp.1;
      temp := r12(b2, c2, d2, e2, a2, w3, 12);
      b2 := temp.0; d2 := temp.1;
      temp := r11(a1, b1, c1, d1, e1, w15, 8);
      a1 := temp.0; c1 := temp.1;
      temp := r12(a2, b2, c2, d2, e2, w12, 6);
      a2 := temp.0; c2 := temp.1;

      temp := r21(e1, a1, b1, c1, d1, w7, 7);
      e1 := temp.0; b1 := temp.1;
      temp := r22(e2, a2, b2, c2, d2, w6, 9);
      e2 := temp.0; b2 := temp.1;
      temp := r21(d1, e1, a1, b1, c1, w4, 6);
      d1 := temp.0; a1 := temp.1;
      temp := r22(d2, e2, a2, b2, c2, w11, 13);
      d2 := temp.0; a2 := temp.1;
      temp := r21(c1, d1, e1, a1, b1, w13, 8);
      c1 := temp.0; e1 := temp.1;
      temp := r22(c2, d2, e2, a2, b2, w3, 15);
      c2 := temp.0; e2 := temp.1;
      temp := r21(b1, c1, d1, e1, a1, w1, 13);
      b1 := temp.0; d1 := temp.1;
      temp := r22(b2, c2, d2, e2, a2, w7, 7);
      b2 := temp.0; d2 := temp.1;
      temp := r21(a1, b1, c1, d1, e1, w10, 11);
      a1 := temp.0; c1 := temp.1;
      temp := r22(a2, b2, c2, d2, e2, w0, 12);
      a2 := temp.0; c2 := temp.1;
      temp := r21(e1, a1, b1, c1, d1, w6, 9);
      e1 := temp.0; b1 := temp.1;
      temp := r22(e2, a2, b2, c2, d2, w13, 8);
      e2 := temp.0; b2 := temp.1;
      temp := r21(d1, e1, a1, b1, c1, w15, 7);
      d1 := temp.0; a1 := temp.1;
      temp := r22(d2, e2, a2, b2, c2, w5, 9);
      d2 := temp.0; a2 := temp.1;
      temp := r21(c1, d1, e1, a1, b1, w3, 15);
      c1 := temp.0; e1 := temp.1;
      temp := r22(c2, d2, e2, a2, b2, w10, 11);
      c2 := temp.0; e2 := temp.1;
      temp := r21(b1, c1, d1, e1, a1, w12, 7);
      b1 := temp.0; d1 := temp.1;
      temp := r22(b2, c2, d2, e2, a2, w14, 7);
      b2 := temp.0; d2 := temp.1;
      temp := r21(a1, b1, c1, d1, e1, w0, 12);
      a1 := temp.0; c1 := temp.1;
      temp := r22(a2, b2, c2, d2, e2, w15, 7);
      a2 := temp.0; c2 := temp.1;
      temp := r21(e1, a1, b1, c1, d1, w9, 15);
      e1 := temp.0; b1 := temp.1;
      temp := r22(e2, a2, b2, c2, d2, w8, 12);
      e2 := temp.0; b2 := temp.1;
      temp := r21(d1, e1, a1, b1, c1, w5, 9);
      d1 := temp.0; a1 := temp.1;
      temp := r22(d2, e2, a2, b2, c2, w12, 7);
      d2 := temp.0; a2 := temp.1;
      temp := r21(c1, d1, e1, a1, b1, w2, 11);
      c1 := temp.0; e1 := temp.1;
      temp := r22(c2, d2, e2, a2, b2, w4, 6);
      c2 := temp.0; e2 := temp.1;
      temp := r21(b1, c1, d1, e1, a1, w14, 7);
      b1 := temp.0; d1 := temp.1;
      temp := r22(b2, c2, d2, e2, a2, w9, 15);
      b2 := temp.0; d2 := temp.1;
      temp := r21(a1, b1, c1, d1, e1, w11, 13);
      a1 := temp.0; c1 := temp.1;
      temp := r22(a2, b2, c2, d2, e2, w1, 13);
      a2 := temp.0; c2 := temp.1;
      temp := r21(e1, a1, b1, c1, d1, w8, 12);
      e1 := temp.0; b1 := temp.1;
      temp := r22(e2, a2, b2, c2, d2, w2, 11);
      e2 := temp.0; b2 := temp.1;

      temp := r31(d1, e1, a1, b1, c1, w3, 11);
      d1 := temp.0; a1 := temp.1;
      temp := r32(d2, e2, a2, b2, c2, w15, 9);
      d2 := temp.0; a2 := temp.1;
      temp := r31(c1, d1, e1, a1, b1, w10, 13);
      c1 := temp.0; e1 := temp.1;
      temp := r32(c2, d2, e2, a2, b2, w5, 7);
      c2 := temp.0; e2 := temp.1;
      temp := r31(b1, c1, d1, e1, a1, w14, 6);
      b1 := temp.0; d1 := temp.1;
      temp := r32(b2, c2, d2, e2, a2, w1, 15);
      b2 := temp.0; d2 := temp.1;
      temp := r31(a1, b1, c1, d1, e1, w4, 7);
      a1 := temp.0; c1 := temp.1;
      temp := r32(a2, b2, c2, d2, e2, w3, 11);
      a2 := temp.0; c2 := temp.1;
      temp := r31(e1, a1, b1, c1, d1, w9, 14);
      e1 := temp.0; b1 := temp.1;
      temp := r32(e2, a2, b2, c2, d2, w7, 8);
      e2 := temp.0; b2 := temp.1;
      temp := r31(d1, e1, a1, b1, c1, w15, 9);
      d1 := temp.0; a1 := temp.1;
      temp := r32(d2, e2, a2, b2, c2, w14, 6);
      d2 := temp.0; a2 := temp.1;
      temp := r31(c1, d1, e1, a1, b1, w8, 13);
      c1 := temp.0; e1 := temp.1;
      temp := r32(c2, d2, e2, a2, b2, w6, 6);
      c2 := temp.0; e2 := temp.1;
      temp := r31(b1, c1, d1, e1, a1, w1, 15);
      b1 := temp.0; d1 := temp.1;
      temp := r32(b2, c2, d2, e2, a2, w9, 14);
      b2 := temp.0; d2 := temp.1;
      temp := r31(a1, b1, c1, d1, e1, w2, 14);
      a1 := temp.0; c1 := temp.1;
      temp := r32(a2, b2, c2, d2, e2, w11, 12);
      a2 := temp.0; c2 := temp.1;
      temp := r31(e1, a1, b1, c1, d1, w7, 8);
      e1 := temp.0; b1 := temp.1;
      temp := r32(e2, a2, b2, c2, d2, w8, 13);
      e2 := temp.0; b2 := temp.1;
      temp := r31(d1, e1, a1, b1, c1, w0, 13);
      d1 := temp.0; a1 := temp.1;
      temp := r32(d2, e2, a2, b2, c2, w12, 5);
      d2 := temp.0; a2 := temp.1;
      temp := r31(c1, d1, e1, a1, b1, w6, 6);
      c1 := temp.0; e1 := temp.1;
      temp := r32(c2, d2, e2, a2, b2, w2, 14);
      c2 := temp.0; e2 := temp.1;
      temp := r31(b1, c1, d1, e1, a1, w13, 5);
      b1 := temp.0; d1 := temp.1;
      temp := r32(b2, c2, d2, e2, a2, w10, 13);
      b2 := temp.0; d2 := temp.1;
      temp := r31(a1, b1, c1, d1, e1, w11, 12);
      a1 := temp.0; c1 := temp.1;
      temp := r32(a2, b2, c2, d2, e2, w0, 13);
      a2 := temp.0; c2 := temp.1;
      temp := r31(e1, a1, b1, c1, d1, w5, 7);
      e1 := temp.0; b1 := temp.1;
      temp := r32(e2, a2, b2, c2, d2, w4, 7);
      e2 := temp.0; b2 := temp.1;
      temp := r31(d1, e1, a1, b1, c1, w12, 5);
      d1 := temp.0; a1 := temp.1;
      temp := r32(d2, e2, a2, b2, c2, w13, 5);
      d2 := temp.0; a2 := temp.1;

      temp := r41(c1, d1, e1, a1, b1, w1, 11);
      c1 := temp.0; e1 := temp.1;
      temp := r42(c2, d2, e2, a2, b2, w8, 15);
      c2 := temp.0; e2 := temp.1;
      temp := r41(b1, c1, d1, e1, a1, w9, 12);
      b1 := temp.0; d1 := temp.1;
      temp := r42(b2, c2, d2, e2, a2, w6, 5);
      b2 := temp.0; d2 := temp.1;
      temp := r41(a1, b1, c1, d1, e1, w11, 14);
      a1 := temp.0; c1 := temp.1;
      temp := r42(a2, b2, c2, d2, e2, w4, 8);
      a2 := temp.0; c2 := temp.1;
      temp := r41(e1, a1, b1, c1, d1, w10, 15);
      e1 := temp.0; b1 := temp.1;
      temp := r42(e2, a2, b2, c2, d2, w1, 11);
      e2 := temp.0; b2 := temp.1;
      temp := r41(d1, e1, a1, b1, c1, w0, 14);
      d1 := temp.0; a1 := temp.1;
      temp := r42(d2, e2, a2, b2, c2, w3, 14);
      d2 := temp.0; a2 := temp.1;
      temp := r41(c1, d1, e1, a1, b1, w8, 15);
      c1 := temp.0; e1 := temp.1;
      temp := r42(c2, d2, e2, a2, b2, w11, 14);
      c2 := temp.0; e2 := temp.1;
      temp := r41(b1, c1, d1, e1, a1, w12, 9);
      b1 := temp.0; d1 := temp.1;
      temp := r42(b2, c2, d2, e2, a2, w15, 6);
      b2 := temp.0; d2 := temp.1;
      temp := r41(a1, b1, c1, d1, e1, w4, 8);
      a1 := temp.0; c1 := temp.1;
      temp := r42(a2, b2, c2, d2, e2, w0, 14);
      a2 := temp.0; c2 := temp.1;
      temp := r41(e1, a1, b1, c1, d1, w13, 9);
      e1 := temp.0; b1 := temp.1;
      temp := r42(e2, a2, b2, c2, d2, w5, 6);
      e2 := temp.0; b2 := temp.1;
      temp := r41(d1, e1, a1, b1, c1, w3, 14);
      d1 := temp.0; a1 := temp.1;
      temp := r42(d2, e2, a2, b2, c2, w12, 9);
      d2 := temp.0; a2 := temp.1;
      temp := r41(c1, d1, e1, a1, b1, w7, 5);
      c1 := temp.0; e1 := temp.1;
      temp := r42(c2, d2, e2, a2, b2, w2, 12);
      c2 := temp.0; e2 := temp.1;
      temp := r41(b1, c1, d1, e1, a1, w15, 6);
      b1 := temp.0; d1 := temp.1;
      temp := r42(b2, c2, d2, e2, a2, w13, 9);
      b2 := temp.0; d2 := temp.1;
      temp := r41(a1, b1, c1, d1, e1, w14, 8);
      a1 := temp.0; c1 := temp.1;
      temp := r42(a2, b2, c2, d2, e2, w9, 12);
      a2 := temp.0; c2 := temp.1;
      temp := r41(e1, a1, b1, c1, d1, w5, 6);
      e1 := temp.0; b1 := temp.1;
      temp := r42(e2, a2, b2, c2, d2, w7, 5);
      e2 := temp.0; b2 := temp.1;
      temp := r41(d1, e1, a1, b1, c1, w6, 5);
      d1 := temp.0; a1 := temp.1;
      temp := r42(d2, e2, a2, b2, c2, w10, 15);
      d2 := temp.0; a2 := temp.1;
      temp := r41(c1, d1, e1, a1, b1, w2, 12);
      c1 := temp.0; e1 := temp.1;
      temp := r42(c2, d2, e2, a2, b2, w14, 8);
      c2 := temp.0; e2 := temp.1;

      temp := r51(b1, c1, d1, e1, a1, w4, 9);
      b1 := temp.0; d1 := temp.1;
      temp := r52(b2, c2, d2, e2, a2, w12, 8);
      b2 := temp.0; d2 := temp.1;
      temp := r51(a1, b1, c1, d1, e1, w0, 15);
      a1 := temp.0; c1 := temp.1;
      temp := r52(a2, b2, c2, d2, e2, w15, 5);
      a2 := temp.0; c2 := temp.1;
      temp := r51(e1, a1, b1, c1, d1, w5, 5);
      e1 := temp.0; b1 := temp.1;
      temp := r52(e2, a2, b2, c2, d2, w10, 12);
      e2 := temp.0; b2 := temp.1;
      temp := r51(d1, e1, a1, b1, c1, w9, 11);
      d1 := temp.0; a1 := temp.1;
      temp := r52(d2, e2, a2, b2, c2, w4, 9);
      d2 := temp.0; a2 := temp.1;
      temp := r51(c1, d1, e1, a1, b1, w7, 6);
      c1 := temp.0; e1 := temp.1;
      temp := r52(c2, d2, e2, a2, b2, w1, 12);
      c2 := temp.0; e2 := temp.1;
      temp := r51(b1, c1, d1, e1, a1, w12, 8);
      b1 := temp.0; d1 := temp.1;
      temp := r52(b2, c2, d2, e2, a2, w5, 5);
      b2 := temp.0; d2 := temp.1;
      temp := r51(a1, b1, c1, d1, e1, w2, 13);
      a1 := temp.0; c1 := temp.1;
      temp := r52(a2, b2, c2, d2, e2, w8, 14);
      a2 := temp.0; c2 := temp.1;
      temp := r51(e1, a1, b1, c1, d1, w10, 12);
      e1 := temp.0; b1 := temp.1;
      temp := r52(e2, a2, b2, c2, d2, w7, 6);
      e2 := temp.0; b2 := temp.1;
      temp := r51(d1, e1, a1, b1, c1, w14, 5);
      d1 := temp.0; a1 := temp.1;
      temp := r52(d2, e2, a2, b2, c2, w6, 8);
      d2 := temp.0; a2 := temp.1;
      temp := r51(c1, d1, e1, a1, b1, w1, 12);
      c1 := temp.0; e1 := temp.1;
      temp := r52(c2, d2, e2, a2, b2, w2, 13);
      c2 := temp.0; e2 := temp.1;
      temp := r51(b1, c1, d1, e1, a1, w3, 13);
      b1 := temp.0; d1 := temp.1;
      temp := r52(b2, c2, d2, e2, a2, w13, 6);
      b2 := temp.0; d2 := temp.1;
      temp := r51(a1, b1, c1, d1, e1, w8, 14);
      a1 := temp.0; c1 := temp.1;
      temp := r52(a2, b2, c2, d2, e2, w14, 5);
      a2 := temp.0; c2 := temp.1;
      temp := r51(e1, a1, b1, c1, d1, w11, 11);
      e1 := temp.0; b1 := temp.1;
      temp := r52(e2, a2, b2, c2, d2, w0, 15);
      e2 := temp.0; b2 := temp.1;
      temp := r51(d1, e1, a1, b1, c1, w6, 8);
      d1 := temp.0; a1 := temp.1;
      temp := r52(d2, e2, a2, b2, c2, w3, 13);
      d2 := temp.0; a2 := temp.1;
      temp := r51(c1, d1, e1, a1, b1, w15, 5);
      c1 := temp.0; e1 := temp.1;
      temp := r52(c2, d2, e2, a2, b2, w9, 11);
      c2 := temp.0; e2 := temp.1;
      temp := r51(b1, c1, d1, e1, a1, w13, 6);
      b1 := temp.0; d1 := temp.1;
      temp := r52(b2, c2, d2, e2, a2, w11, 11);
      b2 := temp.0; d2 := temp.1;

      let t : Nat32 = s[0];
      s[0] := s[1] +% c1 +% d2;
      s[1] := s[2] +% d1 +% e2;
      s[2] := s[3] +% e1 +% a2;
      s[3] := s[4] +% a1 +% b2;
      s[4] := t +% b1 +% c2;
    };

    public func write(data : [Nat8]) {
      var bufsize : Nat = Nat64.toNat(bytes % 64);
      var transformOffset : Nat = 0;

      // Check if the incoming data is enough to fill the buffer
      // which might have data from a previous call.
      if (bufsize > 0 and (bufsize + data.size() >= 64)) {
        // Fill the buffer, and process it.
        for (i in Iter.range(bufsize, 63)) {
          buf[i] := data[i - bufsize];
        };
        // Add the count of processed bytes.
        bytes += 64 - Nat64.fromNat(bufsize);
        transform(Array.freeze(buf), 0);
        // All data in the buffer has been processed, reset buffer data size
        // point transformOffset to index of not-yet processed data.
        transformOffset += 64 - bufsize;
        bufsize := 0;
      };
      // If size of not-yet processed incoming data fits in buffer,
      // process it.
      while (data.size() >= transformOffset + 64) {
        // Process full chunks directly from the source.
        transform(data, transformOffset);
        // Add the count of processed bytes.
        bytes += 64;
        transformOffset += 64;
      };
      // Push any not-yet processed data to buffer.
      for (i in Iter.range(transformOffset, data.size() - 1)) {
        buf[bufsize + i - transformOffset] := data[i];
        bytes += 1;
      };
    };

    public func sum() : [Nat8] {
      let pad : [var Nat8] = Array.init<Nat8>(
        Nat64.toNat(1 + ((119 - (bytes % 64)) % 64)), 0);
      pad[0] := 0x80;

      let sizedesc : [var Nat8] = Array.init<Nat8>(8, 0);
      Common.writeLE64(sizedesc, 0, bytes << 3);

      write(Array.freeze(pad));
      write(Array.freeze(sizedesc));

      let hash : [var Nat8] = Array.init<Nat8>(20, 0);
      Common.writeLE32(hash, 0, s[0]);
      Common.writeLE32(hash, 4, s[1]);
      Common.writeLE32(hash, 8, s[2]);
      Common.writeLE32(hash, 12, s[3]);
      Common.writeLE32(hash, 16, s[4]);

      return Array.freeze(hash);
    };
  };
};
