import Fp "../ec/Fp";
import Jacobi "../ec/Jacobi";
import Common "../Common";
import Types "./Types";
import SHA256 "../../motoko-sha/src/SHA256";

module {
  public type Signature = Types.Signature;
  public type PublicKey = Types.PublicKey;

  // Verify ECDSA signature using SHA256 as a hash function.
  public func verify(signature : Signature, publicKey : PublicKey,
    message : [Nat8]) : Bool {

    let (x, y, curve) = (publicKey.coords.x,
      publicKey.coords.y, publicKey.curve);

    if (signature.r == 0 or signature.s == 0 or
      signature.r >= curve.r or signature.s >= curve.r) {
      return false;
    };

    let (r, s) : (Fp.Fp, Fp.Fp) =
      (Fp.Fp(signature.r, curve.r), Fp.Fp(signature.s, curve.r));
    let h : Fp.Fp =
      Fp.Fp(Common.readBE256(SHA256.sha256(message), 0), curve.r);

    let sInverse : Fp.Fp = s.inverse();
    let a : Fp.Fp = h.mul(sInverse);
    let b : Fp.Fp = r.mul(sInverse);

    return switch(
      Jacobi.toAffine(
        Jacobi.add(
          Jacobi.mulBase(a.value, curve),
          Jacobi.mul(Jacobi.fromAffine(#point (x, y, curve)), b.value)
          )
        ),
      ) {
      case (#point (x2, _, _)) {
        r.isEqual(Fp.Fp(x2.value, curve.r))
      };
      case _ {
        false
      }
    };
  };
};
