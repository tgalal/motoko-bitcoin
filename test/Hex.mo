// Hex decoding imported from
// https://github.com/aviate-labs/encoding.mo/blob/main/src/Hex.mo to
// facilitate in testing.
import Array "mo:base/Array";
import Char "mo:base/Char";
import Iter "mo:base/Iter";
import Nat8 "mo:base/Nat8";
import Result "mo:base/Result";
import Text "mo:base/Text";

module {
    private let base : Nat8   = 16;
    private let hex  : [Char] = [
        '0', '1', '2', '3', 
        '4', '5', '6', '7', 
        '8', '9', 'a', 'b', 
        'c', 'd', 'e', 'f',
    ];

    private func toLower(c : Char) : Char {
        switch (c) {
            case ('A') { 'a' };
            case ('B') { 'b' };
            case ('C') { 'c' };
            case ('D') { 'd' };
            case ('E') { 'e' };
            case ('F') { 'f' };
            case (_)   { c;  };
        };
    };

    public type Hex = Text;
    // Converts the given hexadecimal character to its corresponding binary format.
    // NOTE: a hexadecimal char is just an 4-bit natural number.
    public func decodeChar(c : Char) : Result.Result<Nat8, Text> {
        for (i in hex.keys()) {
            let h = hex[i];
            if (h == c or h == toLower(c)) {
                return #ok(Nat8.fromNat(i));
            }
        };
        #err("unexpected character: " # Char.toText(c));
    };

    // Converts the given hexidecimal text to its corresponding binary format.
    public func decode(t : Hex) : Result.Result<[Nat8], Text> {
        let t_ = if (t.size() % 2 == 0) { t } else { "0" # t };
        let cs = Iter.toArray(t_.chars());
        let ns = Array.init<Nat8>(t_.size() / 2, 0);
        for (i in Iter.range(0, ns.size() - 1)) {
            let j : Nat = i * 2;
            switch (decodeChar(cs[j])) {
                case (#err(e)) { return #err(e); };
                case (#ok(x0)) {
                    switch (decodeChar(cs[j+1])) {
                        case (#err(e)) { return #err(e); };
                        case (#ok(x1)) {
                            ns[i] := x0 * base + x1;
                        };
                    };
                };
            };
        };
        #ok(Array.freeze(ns));
    };
};
