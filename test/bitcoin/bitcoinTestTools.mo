import Affine "../../src/ec/Affine";
import Jacobi "../../src/ec/Jacobi";
import Curves "../../src/ec/Curves";
import Fp "../../src/ec/Fp";
import Types "../../src/bitcoin/Types";
import Common "../../src/Common";
import Wif "../../src/bitcoin/Wif";
import P2pkh "../../src/bitcoin/P2pkh";
import Script "../../src/bitcoin/Script";
import EcdsaTypes "../../src/ecdsa/Types";
import PublicKey "../../src/ecdsa/Publickey";
import Der "../../src/ecdsa/Der";
import Debug "mo:base/Debug";
import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";
import Nat8 "mo:base/Nat8";
import Nat32 "mo:base/Nat32";
import Blob "mo:base/Blob";
import Int "mo:base/Int";

module {
  public type Signature = {r : Nat; s : Nat};
  let curve = Curves.secp256k1;

  // Helper function for operating modulo the curve order.
  func Fr(value : Nat) : Fp.Fp {
    return Fp.Fp(value, curve.r);
  };

  // Helper class for assisting with signing with predetermined nonces.
  // Constructor is called with a private key and a list of signing nonce.
  // Each call to `sign` consumes a nonce.
  public class EcdsaProxy(privateKey : Wif.WifPrivateKey,
    signingNonces : [Nat]) {

    var nextNonce : Nat = 0;
    let bitcoinPrivateKey = switch (Wif.decode(privateKey)) {
      case (#ok bitcoinPrivateKey) {
        bitcoinPrivateKey
      };
      case (#err msg){
        Debug.trap(msg)
      };
    };

    // Sign given data and return Der encoded signature.
    public func sign(data : Blob, derivationPath : [Blob]) : Blob {
      let signature = ecdsaSign(
        bitcoinPrivateKey.key,
        signingNonces[nextNonce],
        Blob.toArray(data)
      );
      nextNonce += 1;

      let encodedOutput : [var Nat8] = Array.init<Nat8>(64, 0);
      Common.writeBE256(encodedOutput, 0, signature.r);
      Common.writeBE256(encodedOutput, 32, signature.s);
      return Blob.fromArray(Array.freeze(encodedOutput));
    };

    // Returns the public key associated to `bitcoinPrivateKey`.
    public func publicKey() : (Blob, Blob) {
      let publicPoint = Jacobi.toAffine(Jacobi.mulBase(bitcoinPrivateKey.key,
        Curves.secp256k1));

      return switch (PublicKey.decode(#point publicPoint)) {
        case (#ok publicKey) {
          (
            Blob.fromArray(PublicKey.toSec1(publicKey, false).0),
            Blob.fromArray([])
          )
        };
        case (#err msg) {
          Debug.trap(msg)
        };
      };
    };

    // Returns the P2pkh address associated to `bitcoinPrivateKey`.
    public func p2pkhAddress() : Types.P2PkhAddress {
      P2pkh.deriveAddress(
        bitcoinPrivateKey.network,
        (Blob.toArray(publicKey().0), Curves.secp256k1));
    };
  };

  // ECDSA signing for testing transaction signatures.
  // `sk` is the secret key.
  // `rand` is the signing nonce.
  // `message` is the data to sign.
  func ecdsaSign(sk : Nat, rand : Nat, hash : [Nat8]) : Signature {
    let h = Common.readBE256(hash, 0);
    switch(Jacobi.toAffine(Jacobi.mulBase(rand, Curves.secp256k1))) {
      case (#point (x, y, curve)) {
        let r = x.value;
        if (r == 0) {
          Debug.trap("r = 0, use different rand.");
        };
        let s = Fr(rand).inverse().mul(
          Fr(h + sk * r)
        );
        if (s.value == 0) {
          Debug.trap("s = 0, use different rand.");
        };

        let finalS : Int = if (s.value > curve.r/2) {
          curve.r - s.value
        } else {
          s.value
        };
        return {r = r; s = Int.abs(finalS)};
      };
      case (#infinity (_)) {
        Debug.trap("Computed infinity point, use different rand.");
      };
    };
  };
};
