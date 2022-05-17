import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Nat32 "mo:base/Nat32";
import Array "mo:base/Array";
import Common "../Common";
import ByteUtils "../ByteUtils";
import Debug "mo:base/Debug";
import Result "mo:base/Result";

module Script {
  let maxNat8 = 0xff;
  let maxNat16 = 0xffff;
  let maxNat32 = 0xffffffff;
  // Full set of opcodes from Bitcoin Core 23.0.
  // Not all opcodes are supported: see encodeOpcode and decodeOpcode.
  public type Opcode = {
    #OP_0;
    #OP_FALSE;
    #OP_PUSHDATA1;
    #OP_PUSHDATA2;
    #OP_PUSHDATA4;
    #OP_1NEGATE;
    #OP_RESERVED;
    #OP_1;
    #OP_TRUE;
    #OP_2;
    #OP_3;
    #OP_4;
    #OP_5;
    #OP_6;
    #OP_7;
    #OP_8;
    #OP_9;
    #OP_10;
    #OP_11;
    #OP_12;
    #OP_13;
    #OP_14;
    #OP_15;
    #OP_16;

    // control
    #OP_NOP;
    #OP_VER;
    #OP_IF;
    #OP_NOTIF;
    #OP_VERIF;
    #OP_VERNOTIF;
    #OP_ELSE;
    #OP_ENDIF;
    #OP_VERIFY;
    #OP_RETURN;

    // stack ops
    #OP_TOALTSTACK;
    #OP_FROMALTSTACK;
    #OP_2DROP;
    #OP_2DUP;
    #OP_3DUP;
    #OP_2OVER;
    #OP_2ROT;
    #OP_2SWAP;
    #OP_IFDUP;
    #OP_DEPTH;
    #OP_DROP;
    #OP_DUP;
    #OP_NIP;
    #OP_OVER;
    #OP_PICK;
    #OP_ROLL;
    #OP_ROT;
    #OP_SWAP;
    #OP_TUCK;

    // splice ops
    #OP_CAT;
    #OP_SUBSTR;
    #OP_LEFT;
    #OP_RIGHT;
    #OP_SIZE;

    // bit logic
    #OP_INVERT;
    #OP_AND;
    #OP_OR;
    #OP_XOR;
    #OP_EQUAL;
    #OP_EQUALVERIFY;
    #OP_RESERVED1;
    #OP_RESERVED2;

    // numeric
    #OP_1ADD;
    #OP_1SUB;
    #OP_2MUL;
    #OP_2DIV;
    #OP_NEGATE;
    #OP_ABS;
    #OP_NOT;
    #OP_0NOTEQUAL;

    #OP_ADD;
    #OP_SUB;
    #OP_MUL;
    #OP_DIV;
    #OP_MOD;
    #OP_LSHIFT;
    #OP_RSHIFT;

    #OP_BOOLAND;
    #OP_BOOLOR;
    #OP_NUMEQUAL;
    #OP_NUMEQUALVERIFY;
    #OP_NUMNOTEQUAL;
    #OP_LESSTHAN;
    #OP_GREATERTHAN;
    #OP_LESSTHANOREQUAL;
    #OP_GREATERTHANOREQUAL;
    #OP_MIN;
    #OP_MAX;

    #OP_WITHIN;

    // crypto
    #OP_RIPEMD160;
    #OP_SHA1;
    #OP_SHA256;
    #OP_HASH160;
    #OP_HASH256;
    #OP_CODESEPARATOR;
    #OP_CHECKSIG;
    #OP_CHECKSIGVERIFY;
    #OP_CHECKMULTISIG;
    #OP_CHECKMULTISIGVERIFY;

    // expansion
    #OP_NOP1;
    #OP_CHECKLOCKTIMEVERIFY;
    #OP_NOP2;
    #OP_CHECKSEQUENCEVERIFY;
    #OP_NOP3;
    #OP_NOP4;
    #OP_NOP5;
    #OP_NOP6;
    #OP_NOP7;
    #OP_NOP8;
    #OP_NOP9;
    #OP_NOP10;

    // Opcode added by BIP 342 (Tapscript)
    #OP_CHECKSIGADD;

    #OP_INVALIDOPCODE;
  };

  // An instruction is either an opcode or data.
  public type Instruction = {
    #opcode : Opcode;
    #data : [Nat8];
  };

  // A script is an array of instructions.
  public type Script = [Instruction];

  // Convert given opcode to its byte representation.
  func encodeOpcode(opcode : Opcode) : Nat8 {
    return switch (opcode) {
      case (#OP_0) {
        0x00;
      };
      case (#OP_PUSHDATA1) {
        0x4c;
      };
      case (#OP_1NEGATE) {
        0x4f;
      };
      case (#OP_1) {
        0x51;
      };
      case (#OP_2) {
        0x52;
      };
      case (#OP_3) {
        0x53;
      };
      case (#OP_4) {
        0x54;
      };
      case (#OP_5) {
        0x55;
      };
      case (#OP_6) {
        0x56;
      };
      case (#OP_7) {
        0x57;
      };
      case (#OP_8) {
        0x58;
      };
      case (#OP_9) {
        0x59;
      };
      case (#OP_10) {
        0x5a;
      };
      case (#OP_11) {
        0x5b;
      };
      case (#OP_12) {
        0x5c;
      };
      case (#OP_13) {
        0x5d;
      };
      case (#OP_14) {
        0x5e;
      };
      case (#OP_15) {
        0x5f;
      };
      case (#OP_16) {
        0x60;
      };
      case (#OP_NOP) {
        0x61;
      };
      case (#OP_IF) {
        0x63;
      };
      case (#OP_VERIF) {
        0x65;
      };
      case (#OP_ELSE) {
        0x67;
      };
      case (#OP_ENDIF) {
        0x68;
      };
      case (#OP_RETURN) {
        0x6a;
      };
      case (#OP_DROP) {
        0x75;
      };
      case (#OP_DUP) {
        0x76;
      };
      case (#OP_NIP) {
        0x77;
      };
      case (#OP_SWAP) {
        0x7c;
      };
      case (#OP_PICK) {
        0x79;
      };
      case (#OP_SIZE) {
        0x82;
      };
      case (#OP_EQUAL) {
        0x87;
      };
      case (#OP_EQUALVERIFY) {
        0x88;
      };
      case (#OP_1ADD) {
        0x8b;
      };
      case (#OP_1SUB) {
        0x8c;
      };
      case (#OP_NOT) {
        0x91;
      };
      case (#OP_BOOLAND) {
        0x9a;
      };
      case (#OP_ADD) {
        0x93;
      };
      case (#OP_WITHIN) {
        0xa5;
      };
      case (#OP_SHA256) {
        0xa8;
      };
      case (#OP_HASH160) {
        0xa9;
      };
      case (#OP_CODESEPARATOR) {
        0xab;
      };
      case (#OP_CHECKSIG) {
        0xac;
      };
      case (#OP_CHECKSIGVERIFY) {
        0xad;
      };
      case (#OP_CHECKMULTISIG) {
        0xae;
      };
      case (#OP_CHECKLOCKTIMEVERIFY) {
        0xb1;
      };
      case (#OP_CHECKSEQUENCEVERIFY) {
        0xb2;
      };
      case _ {
        Debug.trap(debug_show("Unsupported opcode", opcode));
      }
    };
  };

  // Decode given opcode id.
  func decodeOpcode(id : Nat8) : ?Opcode {
    return do ? {
      switch id {
        case 0x4c {
          #OP_PUSHDATA1
        };
        case 0x4d {
          #OP_PUSHDATA2
        };
        case 0x4e {
          #OP_PUSHDATA4
        };
        case 0x4f {
          #OP_1NEGATE
        };
        case 0x51 {
          #OP_1
        };
        case 0x52 {
          #OP_2
        };
        case 0x53 {
          #OP_3
        };
        case 0x54 {
          #OP_4
        };
        case 0x55 {
          #OP_5
        };
        case 0x56 {
          #OP_6
        };
        case 0x57 {
          #OP_7
        };
        case 0x58 {
          #OP_8
        };
        case 0x59 {
          #OP_9
        };
        case 0x5a {
          #OP_10
        };
        case 0x5b {
          #OP_11
        };
        case 0x5c {
          #OP_12
        };
        case 0x5d {
          #OP_13
        };
        case 0x5e {
          #OP_14
        };
        case 0x5f {
          #OP_15
        };
        case 0x60 {
          #OP_16
        };
        case 0x61 {
          #OP_NOP
        };
        case 0x62 {
          #OP_VER
        };
        case 0x63{
          #OP_IF
        };
        case 0x65 {
          #OP_VERIF
        };
        case 0x67 {
          #OP_ELSE
        };
        case 0x68 {
          #OP_ENDIF
        };
        case 0x6a {
          #OP_RETURN
        };
        case 0x6b {
          #OP_TOALTSTACK
        };
        case 0x6f {
          #OP_3DUP
        };
        case 0x75 {
          #OP_DROP
        };
        case 0x76 {
          #OP_DUP
        };
        case 0x77 {
          #OP_NIP
        };
        case 0x7c {
          #OP_SWAP
        };
        case 0x79 {
          #OP_PICK
        };
        case 0x82 {
          #OP_SIZE
        };
        case 0x87 {
          #OP_EQUAL
        };
        case 0x88 {
          #OP_EQUALVERIFY
        };
        case 0x8b {
          #OP_1ADD
        };
        case 0x8c {
          #OP_1SUB
        };
        case 0x91 {
          #OP_NOT
        };
        case 0x93 {
          #OP_ADD
        };
        case 0x9a {
          #OP_BOOLAND
        };
        case 0x9d {
          #OP_NUMEQUALVERIFY
        };
        case 0xa5 {
          #OP_WITHIN
        };
        case 0xa8 {
          #OP_SHA256
        };
        case 0xa9 {
          #OP_HASH160
        };
        case 0xaa {
         #OP_HASH256
        };
        case 0xab {
          #OP_CODESEPARATOR
        };
        case 0xac {
          #OP_CHECKSIG
        };
        case 0xad {
          #OP_CHECKSIGVERIFY
        };
        case 0xae {
          #OP_CHECKMULTISIG
        };
        case 0xb1 {
          #OP_CHECKLOCKTIMEVERIFY
        };
        case 0xb2 {
          #OP_CHECKSEQUENCEVERIFY
        };
        case _ {
          null!
        };
      };
    };
  };

  // Deserialize Script from data. If readSize is true, will read and use the
  // script size from data. Reading size is required when deserializing scripts
  // that were serialized as part of transactions. If readSize is false, will
  // read all bytes in data.
  public func fromBytes(data : Iter.Iter<Nat8>, readSize : Bool)
    : Result.Result<Script, Text> {
    let size = if (readSize) {
      switch (ByteUtils.readVarint(data)) {
        case (?size) {
          size
        };
        case _ {
          return #err ("Could not read size.");
        };
      }
    } else {
      0
    };

    if (readSize and size == 0) {
      // Read a size equals zero, returning an empty script.
      return #ok ([]);
    };

    // There is no trivial way of estimating the number of instructions
    // expected to be read. Thus, will assume 5, which is the p2pkh script
    // expected to be the common scenario.
    let instructionsBuf = Buffer.Buffer<Instruction>(5);
    // Keep traack of total bytes read to not go beyond size if it was set.
    var totalReadCount : Nat = 0;
    let opPushData1 : Nat8 = encodeOpcode(#OP_PUSHDATA1);
    label Reader for (encodedVal in data) {
      totalReadCount += 1;

      let instruction : ?Instruction = do ? {
        if (encodedVal < opPushData1) {
          // Everything below OP_PUSHDATA1 is treated as the size of data to
          // read next.
          let dataSize = Nat8.toNat(encodedVal);
          totalReadCount += dataSize;
          (#data (ByteUtils.read(data, dataSize, false)!))
        } else {
          // Otherwise, it's an opcode.
          (#opcode (decodeOpcode(encodedVal)!))
        };
      };

      // If the instruction is one of 0P_PUSHDATA*, read the data and add it
      // with the instruction.
      let readResult = do ? {
        switch (instruction) {
          case (?(#opcode (#OP_PUSHDATA1))) {
            let dataSize = Nat8.toNat(ByteUtils.readOne(data)!);
            totalReadCount += dataSize + 1;
            instructionsBuf.add(#opcode (#OP_PUSHDATA1));
            instructionsBuf.add(#data (ByteUtils.read(data, dataSize, false)!))
          };
          case (?(#opcode (#OP_PUSHDATA2))) {
            let dataSize = Nat16.toNat(ByteUtils.readLE16(data)!);
            totalReadCount += dataSize + 2;
            instructionsBuf.add(#opcode (#OP_PUSHDATA2));
            instructionsBuf.add(#data (ByteUtils.read(data, dataSize, false)!))
          };
          case (?(#opcode (#OP_PUSHDATA4))) {
            let dataSize = Nat32.toNat(ByteUtils.readLE32(data)!);
            totalReadCount += dataSize + 4;
            instructionsBuf.add(#opcode (#OP_PUSHDATA4));
            instructionsBuf.add(#data (ByteUtils.read(data, dataSize, false)!))
          };
          case (?instruction) {
            instructionsBuf.add(instruction)
          };
          case (null) {
            return #err ("Could not decode opcode: " # Nat8.toText(encodedVal));
          };
        };
      };

      if (readResult == null) {
        return #err ("Error docoding instruction.")
      };

      // Check if the read size has been reached.
      if (readSize and totalReadCount >= size) {
        break Reader;
      };
    };

    // If there is a read size which was not reached, then data is not
    // complete.
    if (readSize and totalReadCount < size) {
      return #err "Truncated script.";
    };
    return #ok (instructionsBuf.toArray());
  };

  // Serialize given script to bytes.
  public func toBytes(script : Script) : [Nat8] {
    let buf : Buffer.Buffer<Nat8> = Buffer.Buffer<Nat8>(script.size());
    let opPushData1 : Nat = Nat8.toNat(encodeOpcode(#OP_PUSHDATA1));

    for (instruction in script.vals()) {
      switch (instruction) {
        case (#opcode(opcode)) {
          buf.add(encodeOpcode(opcode));
        };
        case (#data data) {
          if (data.size() < opPushData1) {
            buf.add(Nat8.fromIntWrap(data.size()));
          } else if (data.size() <= maxNat8) {
            // Data for OP_PUSHDATA1.
            buf.add(Nat8.fromIntWrap(data.size()));
          } else if (data.size() <= maxNat16) {
            // Data for OP_PUSHDATA2.
            let sizeData = Array.init<Nat8>(2, 0);
            Common.writeLE16(sizeData, 0, Nat16.fromIntWrap(data.size()));
            for (item in sizeData.vals()) {
              buf.add(item);
            };
          } else if (data.size() <= maxNat32) {
            // Data for OP_PUSHDATA4.
            let sizeData = Array.init<Nat8>(4, 0);
            Common.writeLE32(sizeData, 0, Nat32.fromIntWrap(data.size()));
            for (item in sizeData.vals()) {
              buf.add(item);
            };
          } else {
            Debug.trap("Data too long to encode.");
          };
          // Copy data into buffer.
          for (item in data.vals()) {
            buf.add(item);
          };
        };
      };
    };

    // Prepend buffer size as varint and return.
    let encodedBufSize = ByteUtils.writeVarint(buf.size());
    return Array.tabulate<Nat8>(encodedBufSize.size() + buf.size(),
      func (i) {
        if (i < encodedBufSize.size()) {
          encodedBufSize[i];
        } else {
          buf.get(i - encodedBufSize.size());
        };
      });
  };
};
