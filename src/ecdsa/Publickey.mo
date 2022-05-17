import Affine "../ec/Affine";
import Curves "../ec/Curves";
import Hash "../Hash";
import Fp "../ec/Fp";
import Result "mo:base/Result";
import Types "./Types";

module {
  type PublicKey = Types.PublicKey;
  type EncodedPublicKey = Types.EncodedPublicKey;

  // Decode a public key from several possible forms.
  public func decode(pk : EncodedPublicKey)
    : Result.Result<Types.PublicKey, Text> {
    return switch (pk) {
      case (#point (point)) {
        fromPoint(point)
      };
      case (#sec1 (data, curve)) {
        fromBytes(data, curve)
      };
    };
  };

  // Deserialize given data to public key. This supports compressed and
  // uncompressed SEC-1 formats.
  // Returns error result if deserialize fails or deserialized point is at
  // infinity.
  func fromBytes(data : [Nat8], curve : Curves.Curve)
    : Result.Result<PublicKey, Text> {

    return switch(Affine.fromBytes(data, curve)) {
      case (null) {
        #err("Could not deserialize data.")
      };
      case (?(point)) {
        fromPoint(point)
      };
    };
  };

  // Creates a PublicKey out of given point.
  // Returns error if point is at infinity or not on curve.
  func fromPoint(point : Affine.Point) : Result.Result<PublicKey, Text> {
    return switch(point) {
      case (#infinity(_)) {
        #err("Can't create public key from point at infinity.")
      };
      case (#point p) {
        if (Affine.isOnCurve(point)) {
          #ok ({
            coords = {
              x = p.0;
              y = p.1;
            };
            curve = p.2;
          });
          // #ok(_PublicKey(p))
        } else {
          #err("Point not on curve.")
        };
      };
    };
  };

  // Converts given public key to SEC1 format.
  public func toSec1(pk : PublicKey,
    compressed : Bool) : Types.Sec1PublicKey  {
    let point : Affine.Point = #point (pk.coords.x, pk.coords.y, pk.curve);
    return (Affine.toBytes(point, compressed), pk.curve);
  };
};
