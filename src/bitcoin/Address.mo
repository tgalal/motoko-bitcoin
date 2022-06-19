import P2pkh "./P2pkh";
import Script "./Script";
import Types "./Types";
import Result "mo:base/Result";

module {
  // Obtain scriptPubKey from given address.
  public func scriptPubKey(
    address : Types.Address) : Result.Result<Script.Script, Text> {
    return switch (address) {
      case (#p2pkh p2pkhAddr) {
        return P2pkh.makeScript(p2pkhAddr)
      };
    };
  };

  // Check if the given addresses are equal.
  public func isEqual(address1 : Types.Address,
    address2 : Types.Address) : Bool  {
      return switch (address1, address2) {
        case (#p2pkh address1, #p2pkh address2) {
          address1 == address2
        };
      };
    };
};
