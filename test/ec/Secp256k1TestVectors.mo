import TestUtils "../TestUtils";

module {
  public type SerializationVector = {
    coords : ?(Nat, Nat);
    uncompressed : [Nat8];
    compressed : [Nat8];
  };

  public type DoublingVector = {
    desc : Text;
    coords : ?(Nat, Nat);
    output : ?(Nat, Nat);
  };

  public type MultiplicationVector = {
    desc : Text;
    coords : ?(Nat, Nat);
    multiplicand : Nat;
    output : ?(Nat, Nat);
  };

  public type BaseMultiplicationVector = {
    multiplicand : Nat;
    output : (Nat, Nat);
  };

  public type AdditionVector = {
    desc: Text;
    coords1: ?(Nat, Nat);
    coords2: ?(Nat, Nat);
    output : ?(Nat, Nat);
  };

  public let doublingVectors : [DoublingVector] = [
    {
      desc = "Double infinity is infinity";
      coords = null;
      output = null;
    },
    {
      desc = "";
      coords = ?(
        0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798,
        0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8,
      );
      output = ?(
        0xc6047f9441ed7d6d3045406e95c07cd85c778e4b8cef3ca7abac09b95c709ee5,
        0x1ae168fea63dc339a3c58419466ceaeef7f632653266d0e1236431a950cfe52a,
      );
    }
  ];

  public let additionVectors : [AdditionVector] = [
    {
      desc = "Add infinities";
      coords1 = null;
      coords2 = null;
      output = null;
    },
    {
      desc = "Add point with infinity";
      coords1 = ?(
        0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798,
        0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8,
      );
      coords2 = null;
      output = ?(
        0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798,
        0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8,
      );
    },
    {
      desc = "Add point with its inverse";
      coords1 = ?(
        0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798,
        0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8,
      );
      coords2 = ?(
        0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798,
        0xb7c52588d95c3b9aa25b0403f1eef75702e84bb7597aabe663b82f6f04ef2777,
      );
      output = null;
    },
    {
      desc = "Add point to itself";
      coords1 = ?(
        0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798,
        0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8,
      );
      coords2 = ?(
        0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798,
        0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8,
      );
      output = ?(
        0xc6047f9441ed7d6d3045406e95c07cd85c778e4b8cef3ca7abac09b95c709ee5,
        0x1ae168fea63dc339a3c58419466ceaeef7f632653266d0e1236431a950cfe52a,
      );
    }
  ];

  public let multiplicationVectors: [MultiplicationVector] = [
    {
      desc = "Multiply with infinity";
      coords = null;
      multiplicand = 5;
      output = null;
    },
    {
      desc = "Multiply with infinity";
      coords = null;
      multiplicand = 1;
      output = null;
    },
    {
      desc = "Multiply with infinity";
      coords = null;
      multiplicand = 0;
      output = null;
    },
    {
      desc = "Multiply by zero";
      coords = ?(
        0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798,
        0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8,
      );
      multiplicand = 0;
      output = null;
    },
    {
      desc = "";
      coords = ?(
        0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798,
        0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8,
      );
      multiplicand = 1;
      output = ?(
        0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798,
        0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8,
      );
    },
    {
      desc = "";
      coords = ?(
        0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798,
        0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8,
      );
      multiplicand = 2;
      output = ?(
        0xc6047f9441ed7d6d3045406e95c07cd85c778e4b8cef3ca7abac09b95c709ee5,
        0x1ae168fea63dc339a3c58419466ceaeef7f632653266d0e1236431a950cfe52a,
      );
    },
  ];

  public let serializationVectors : [SerializationVector] = [
    {
      coords = ?(
        0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798,
        0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8,
      );
      uncompressed = [
        0x04, 0x79, 0xbe, 0x66, 0x7e, 0xf9, 0xdc, 0xbb, 0xac, 0x55, 0xa0, 0x62,
        0x95, 0xce, 0x87, 0x0b, 0x07, 0x02, 0x9b, 0xfc, 0xdb, 0x2d, 0xce, 0x28,
        0xd9, 0x59, 0xf2, 0x81, 0x5b, 0x16, 0xf8, 0x17, 0x98, 0x48, 0x3a, 0xda,
        0x77, 0x26, 0xa3, 0xc4, 0x65, 0x5d, 0xa4, 0xfb, 0xfc, 0x0e, 0x11, 0x08,
        0xa8, 0xfd, 0x17, 0xb4, 0x48, 0xa6, 0x85, 0x54, 0x19, 0x9c, 0x47, 0xd0,
        0x8f, 0xfb, 0x10, 0xd4, 0xb8
      ];
      compressed = [
        0x02, 0x79, 0xbe, 0x66, 0x7e, 0xf9, 0xdc, 0xbb, 0xac, 0x55, 0xa0, 0x62,
        0x95, 0xce, 0x87, 0x0b, 0x07, 0x02, 0x9b, 0xfc, 0xdb, 0x2d, 0xce, 0x28,
        0xd9, 0x59, 0xf2, 0x81, 0x5b, 0x16, 0xf8, 0x17, 0x98
      ];
    }
  ];

  public let baseMultiplicationVectors : [BaseMultiplicationVector] =  [
    {
      multiplicand = 1;
      output = (
        0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798,
        0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8,
      );
    },
    {
      multiplicand = 2;
      output = (
        0xc6047f9441ed7d6d3045406e95c07cd85c778e4b8cef3ca7abac09b95c709ee5,
        0x1ae168fea63dc339a3c58419466ceaeef7f632653266d0e1236431a950cfe52a,
      );
    },
    {
      multiplicand = 3;
      output = (
        0xf9308a019258c31049344f85f89d5229b531c845836f99b08601f113bce036f9,
        0x388f7b0f632de8140fe337e62a37f3566500a99934c2231b6cb9fd7584b8e672,
      );
    },
    {
      multiplicand = 4;
      output = (
        0xe493dbf1c10d80f3581e4904930b1404cc6c13900ee0758474fa94abe8c4cd13,
        0x51ed993ea0d455b75642e2098ea51448d967ae33bfbdfe40cfe97bdc47739922,
      );
    },
    {
      multiplicand = 5;
      output = (
        0x2f8bde4d1a07209355b4a7250a5c5128e88b84bddc619ab7cba8d569b240efe4,
        0xd8ac222636e5e3d6d4dba9dda6c9c426f788271bab0d6840dca87d3aa6ac62d6,
      );
    },
    {
      multiplicand = 6;
      output = (
        0xfff97bd5755eeea420453a14355235d382f6472f8568a18b2f057a1460297556,
        0xae12777aacfbb620f3be96017f45c560de80f0f6518fe4a03c870c36b075f297,
      );
    },
    {
      multiplicand = 7;
      output = (
        0x5cbdf0646e5db4eaa398f365f2ea7a0e3d419b7e0330e39ce92bddedcac4f9bc,
        0x6aebca40ba255960a3178d6d861a54dba813d0b813fde7b5a5082628087264da,
      );
    },
    {
      multiplicand = 8;
      output = (
        0x2f01e5e15cca351daff3843fb70f3c2f0a1bdd05e5af888a67784ef3e10a2a01,
        0x5c4da8a741539949293d082a132d13b4c2e213d6ba5b7617b5da2cb76cbde904,
      );
    },
    {
      multiplicand = 9;
      output = (
        0xacd484e2f0c7f65309ad178a9f559abde09796974c57e714c35f110dfc27ccbe,
        0xcc338921b0a7d9fd64380971763b61e9add888a4375f8e0f05cc262ac64f9c37,
      );
    },
    {
      multiplicand = 10;
      output = (
        0xa0434d9e47f3c86235477c7b1ae6ae5d3442d49b1943c2b752a68e2a47e247c7,
        0x893aba425419bc27a3b6c7e693a24c696f794c2ed877a1593cbee53b037368d7,
      );
    },
    {
      multiplicand = 11;
      output = (
        0x774ae7f858a9411e5ef4246b70c65aac5649980be5c17891bbec17895da008cb,
        0xd984a032eb6b5e190243dd56d7b7b365372db1e2dff9d6a8301d74c9c953c61b,
      );
    },
    {
      multiplicand = 12;
      output = (
        0xd01115d548e7561b15c38f004d734633687cf4419620095bc5b0f47070afe85a,
        0xa9f34ffdc815e0d7a8b64537e17bd81579238c5dd9a86d526b051b13f4062327,
      );
    },
    {
      multiplicand = 13;
      output = (
        0xf28773c2d975288bc7d1d205c3748651b075fbc6610e58cddeeddf8f19405aa8,
        0x0ab0902e8d880a89758212eb65cdaf473a1a06da521fa91f29b5cb52db03ed81,
      );
    },
    {
      multiplicand = 14;
      output = (
        0x499fdf9e895e719cfd64e67f07d38e3226aa7b63678949e6e49b241a60e823e4,
        0xcac2f6c4b54e855190f044e4a7b3d464464279c27a3f95bcc65f40d403a13f5b,
      );
    },
    {
      multiplicand = 15;
      output = (
        0xd7924d4f7d43ea965a465ae3095ff41131e5946f3c85f79e44adbcf8e27e080e,
        0x581e2872a86c72a683842ec228cc6defea40af2bd896d3a5c504dc9ff6a26b58,
      );
    },
    {
      multiplicand = 16;
      output = (
        0xe60fce93b59e9ec53011aabc21c23e97b2a31369b87a5ae9c44ee89e2a6dec0a,
        0xf7e3507399e595929db99f34f57937101296891e44d23f0be1f32cce69616821,
      );
    },
    {
      multiplicand = 17;
      output = (
        0xdefdea4cdb677750a420fee807eacf21eb9898ae79b9768766e4faa04a2d4a34,
        0x4211ab0694635168e997b0ead2a93daeced1f4a04a95c0f6cfb199f69e56eb77,
      );
    },
    {
      multiplicand = 18;
      output = (
        0x5601570cb47f238d2b0286db4a990fa0f3ba28d1a319f5e7cf55c2a2444da7cc,
        0xc136c1dc0cbeb930e9e298043589351d81d8e0bc736ae2a1f5192e5e8b061d58,
      );
    },
    {
      multiplicand = 19;
      output = (
        0x2b4ea0a797a443d293ef5cff444f4979f06acfebd7e86d277475656138385b6c,
        0x85e89bc037945d93b343083b5a1c86131a01f60c50269763b570c854e5c09b7a,
      );
    },
    {
      multiplicand = 20;
      output = (
        0x4ce119c96e2fa357200b559b2f7dd5a5f02d5290aff74b03f3e471b273211c97,
        0x12ba26dcb10ec1625da61fa10a844c676162948271d96967450288ee9233dc3a,
      );
    },
    {
      multiplicand = 112233445566778899;
      output = (
        0xa90cc3d3f3e146daadfc74ca1372207cb4b725ae708cef713a98edd73d99ef29,
        0x5a79d6b289610c68bc3b47f3d72f9788a26a06868b4d8e433e1e2ad76fb7dc76,
      );
    },
    {
      multiplicand = 112233445566778899112233445566778899;
      output = (
        0xe5a2636bcfd412ebf36ec45b19bfb68a1bc5f8632e678132b885f7df99c5e9b3,
        0x736c1ce161ae27b405cafd2a7520370153c2c861ac51d6c1d5985d9606b45f39,
      );
    },
    {
      multiplicand = 28948022309329048855892746252171976963209391069768726095651290785379540373584;
      output = (
        0xa6b594b38fb3e77c6edf78161fade2041f4e09fd8497db776e546c41567feb3c,
        0x71444009192228730cd8237a490feba2afe3d27d7cc1136bc97e439d13330d55,
      );
    },
    {
      multiplicand = 57896044618658097711785492504343953926418782139537452191302581570759080747168;
      output = (
        0x00000000000000000000003b78ce563f89a0ed9414f5aa28ad0d96d6795f9c63,
        0x3f3979bf72ae8202983dc989aec7f2ff2ed91bdd69ce02fc0700ca100e59ddf3,
      );
    },
    {
      multiplicand = 86844066927987146567678238756515930889628173209306178286953872356138621120752;
      output = (
        0xe24ce4beee294aa6350faa67512b99d388693ae4e7f53d19882a6ea169fc1ce1,
        0x8b71e83545fc2b5872589f99d948c03108d36797c4de363ebd3ff6a9e1a95b10,
      );
    },
    {
      multiplicand = 115792089237316195423570985008687907852837564279074904382605163141518161494317;
      output = (
        0x4ce119c96e2fa357200b559b2f7dd5a5f02d5290aff74b03f3e471b273211c97,
        0xed45d9234ef13e9da259e05ef57bb3989e9d6b7d8e269698bafd77106dcc1ff5,
      );
    },
    {
      multiplicand = 115792089237316195423570985008687907852837564279074904382605163141518161494318;
      output = (
        0x2b4ea0a797a443d293ef5cff444f4979f06acfebd7e86d277475656138385b6c,
        0x7a17643fc86ba26c4cbcf7c4a5e379ece5fe09f3afd9689c4a8f37aa1a3f60b5,
      );
    },
    {
      multiplicand = 115792089237316195423570985008687907852837564279074904382605163141518161494319;
      output = (
        0x5601570cb47f238d2b0286db4a990fa0f3ba28d1a319f5e7cf55c2a2444da7cc,
        0x3ec93e23f34146cf161d67fbca76cae27e271f438c951d5e0ae6d1a074f9ded7,
      );
    },
    {
      multiplicand = 115792089237316195423570985008687907852837564279074904382605163141518161494320;
      output = (
        0xdefdea4cdb677750a420fee807eacf21eb9898ae79b9768766e4faa04a2d4a34,
        0xbdee54f96b9cae9716684f152d56c251312e0b5fb56a3f09304e660861a910b8,
      );
    },
    {
      multiplicand = 115792089237316195423570985008687907852837564279074904382605163141518161494321;
      output = (
        0xe60fce93b59e9ec53011aabc21c23e97b2a31369b87a5ae9c44ee89e2a6dec0a,
        0x081caf8c661a6a6d624660cb0a86c8efed6976e1bb2dc0f41e0cd330969e940e,
      );
    },
    {
      multiplicand = 115792089237316195423570985008687907852837564279074904382605163141518161494322;
      output = (
        0xd7924d4f7d43ea965a465ae3095ff41131e5946f3c85f79e44adbcf8e27e080e,
        0xa7e1d78d57938d597c7bd13dd733921015bf50d427692c5a3afb235f095d90d7,
      );
    },
    {
      multiplicand = 115792089237316195423570985008687907852837564279074904382605163141518161494323;
      output = (
        0x499fdf9e895e719cfd64e67f07d38e3226aa7b63678949e6e49b241a60e823e4,
        0x353d093b4ab17aae6f0fbb1b584c2b9bb9bd863d85c06a4339a0bf2afc5ebcd4,
      );
    },
    {
      multiplicand = 115792089237316195423570985008687907852837564279074904382605163141518161494324;
      output = (
        0xf28773c2d975288bc7d1d205c3748651b075fbc6610e58cddeeddf8f19405aa8,
        0xf54f6fd17277f5768a7ded149a3250b8c5e5f925ade056e0d64a34ac24fc0eae,
      );
    },
    {
      multiplicand = 115792089237316195423570985008687907852837564279074904382605163141518161494325;
      output = (
        0xd01115d548e7561b15c38f004d734633687cf4419620095bc5b0f47070afe85a,
        0x560cb00237ea1f285749bac81e8427ea86dc73a2265792ad94fae4eb0bf9d908,
      );
    },
    {
      multiplicand = 115792089237316195423570985008687907852837564279074904382605163141518161494326;
      output = (
        0x774ae7f858a9411e5ef4246b70c65aac5649980be5c17891bbec17895da008cb,
        0x267b5fcd1494a1e6fdbc22a928484c9ac8d24e1d20062957cfe28b3536ac3614,
      );
    },
    {
      multiplicand = 115792089237316195423570985008687907852837564279074904382605163141518161494327;
      output = (
        0xa0434d9e47f3c86235477c7b1ae6ae5d3442d49b1943c2b752a68e2a47e247c7,
        0x76c545bdabe643d85c4938196c5db3969086b3d127885ea6c3411ac3fc8c9358,
      );
    },
    {
      multiplicand = 115792089237316195423570985008687907852837564279074904382605163141518161494328;
      output = (
        0xacd484e2f0c7f65309ad178a9f559abde09796974c57e714c35f110dfc27ccbe,
        0x33cc76de4f5826029bc7f68e89c49e165227775bc8a071f0fa33d9d439b05ff8,
      );
    },
    {
      multiplicand = 115792089237316195423570985008687907852837564279074904382605163141518161494329;
      output = (
        0x2f01e5e15cca351daff3843fb70f3c2f0a1bdd05e5af888a67784ef3e10a2a01,
        0xa3b25758beac66b6d6c2f7d5ecd2ec4b3d1dec2945a489e84a25d3479342132b,
      );
    },
    {
      multiplicand = 115792089237316195423570985008687907852837564279074904382605163141518161494330;
      output = (
        0x5cbdf0646e5db4eaa398f365f2ea7a0e3d419b7e0330e39ce92bddedcac4f9bc,
        0x951435bf45daa69f5ce8729279e5ab2457ec2f47ec02184a5af7d9d6f78d9755,
      );
    },
    {
      multiplicand = 115792089237316195423570985008687907852837564279074904382605163141518161494331;
      output = (
        0xfff97bd5755eeea420453a14355235d382f6472f8568a18b2f057a1460297556,
        0x51ed8885530449df0c4169fe80ba3a9f217f0f09ae701b5fc378f3c84f8a0998,
      );
    },
    {
      multiplicand = 115792089237316195423570985008687907852837564279074904382605163141518161494332;
      output = (
        0x2f8bde4d1a07209355b4a7250a5c5128e88b84bddc619ab7cba8d569b240efe4,
        0x2753ddd9c91a1c292b24562259363bd90877d8e454f297bf235782c459539959,
      );
    },
    {
      multiplicand = 115792089237316195423570985008687907852837564279074904382605163141518161494333;
      output = (
        0xe493dbf1c10d80f3581e4904930b1404cc6c13900ee0758474fa94abe8c4cd13,
        0xae1266c15f2baa48a9bd1df6715aebb7269851cc404201bf30168422b88c630d,
      );
    },
    {
      multiplicand = 115792089237316195423570985008687907852837564279074904382605163141518161494334;
      output = (
        0xf9308a019258c31049344f85f89d5229b531c845836f99b08601f113bce036f9,
        0xc77084f09cd217ebf01cc819d5c80ca99aff5666cb3ddce4934602897b4715bd,
      );
    },
    {
      multiplicand = 115792089237316195423570985008687907852837564279074904382605163141518161494335;
      output = (
        0xc6047f9441ed7d6d3045406e95c07cd85c778e4b8cef3ca7abac09b95c709ee5,
        0xe51e970159c23cc65c3a7be6b99315110809cd9acd992f1edc9bce55af301705,
      );
    },
    {
      multiplicand = 115792089237316195423570985008687907852837564279074904382605163141518161494336;
      output = (
        0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798,
        0xb7c52588d95c3b9aa25b0403f1eef75702e84bb7597aabe663b82f6f04ef2777,
      )
    }
  ];
};
