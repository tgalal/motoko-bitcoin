module {
  public type WycheproofEcdhTestCase = {
    tcId : Nat;
    comment : Text;
    publicKey : Text;
    privateKey : Text;
    output : Text;
    result : Text;
    flags : [Text];
  };

  public let testVectors : [WycheproofEcdhTestCase] = [
    {
      tcId = 1;
      comment = "normal case";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004d8096af8a11e0b80037e1ee68246b5dcbb0aeb1cf1244fd767db80f3fa27da2b396812ea1686e7472e9692eaf3e958e50e9500d3b4c77243db1f2acd67ba9cc4";
      privateKey = "00f4b7ff7cccc98813a69fae3df222bfe3f4e28f764bf91b4a10d8096ce446b254";
      output = "544dfae22af6af939042b1d85b71a1e49e9a5614123c4d6ad0c8af65baf87d65";
      result = "valid";
      flags = [];
    },
    {
      tcId = 2;
      comment = "compressed public key";
      publicKey = "3036301006072a8648ce3d020106052b8104000a03220002d8096af8a11e0b80037e1ee68246b5dcbb0aeb1cf1244fd767db80f3fa27da2b";
      privateKey = "00f4b7ff7cccc98813a69fae3df222bfe3f4e28f764bf91b4a10d8096ce446b254";
      output = "544dfae22af6af939042b1d85b71a1e49e9a5614123c4d6ad0c8af65baf87d65";
      result = "acceptable";
      flags = ["CompressedPoint"];
    },
    {
      tcId = 3;
      comment = "edge case for shared secret";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004965ff42d654e058ee7317cced7caf093fbb180d8d3a74b0dcd9d8cd47a39d5cb9c2aa4daac01a4be37c20467ede964662f12983e0b5272a47a5f2785685d8087";
      privateKey = "00a2b6442a37f8a3764aeff4011a4c422b389a1e509669c43f279c8b7e32d80c3a";
      output = "0000000000000000000000000000000000000000000000000000000000000001";
      result = "valid";
      flags = [];
    },
    {
      tcId = 4;
      comment = "edge case for shared secret";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000406c4b87ba76c6dcb101f54a050a086aa2cb0722f03137df5a922472f1bdc11b982e3c735c4b6c481d09269559f080ad08632f370a054af12c1fd1eced2ea9211";
      privateKey = "00a2b6442a37f8a3764aeff4011a4c422b389a1e509669c43f279c8b7e32d80c3a";
      output = "0000000000000000000000000000000000000000000000000000000000000002";
      result = "valid";
      flags = [];
    },
    {
      tcId = 5;
      comment = "edge case for shared secret";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004bba30eef7967a2f2f08a2ffadac0e41fd4db12a93cef0b045b5706f2853821e6d50b2bf8cbf530e619869e07c021ef16f693cfc0a4b0d4ed5a8f464692bf3d6e";
      privateKey = "00a2b6442a37f8a3764aeff4011a4c422b389a1e509669c43f279c8b7e32d80c3a";
      output = "0000000000000000000000000000000000000000000000000000000000000003";
      result = "valid";
      flags = [];
    },
    {
      tcId = 6;
      comment = "edge case for shared secret";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004166aed3bc281705444f933913f670957a118f8da2c71bd301a90929743e2ca583514a7972e33d6fea1e377ef4184937f67b37e41ef3099c228a88f5bfb67e5b9";
      privateKey = "00a2b6442a37f8a3764aeff4011a4c422b389a1e509669c43f279c8b7e32d80c3a";
      output = "00000000000000000000000000000000ffffffffffffffffffffffffffffffff";
      result = "valid";
      flags = [];
    },
    {
      tcId = 7;
      comment = "edge case for shared secret";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000436e1e76ffdbe8577520b0716eb88c18ea72a49e5a4e5680a7d290093f841cb6e7310728b59c7572c4b35fb6c29c36ebabfc53553c06ecf747fcfbefcf6114e1c";
      privateKey = "00a2b6442a37f8a3764aeff4011a4c422b389a1e509669c43f279c8b7e32d80c3a";
      output = "0000000000000000ffffffffffffffff0000000000000000ffffffffffffffff";
      result = "valid";
      flags = [];
    },
    {
      tcId = 8;
      comment = "edge case for shared secret";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004728e15d578212bc42287c0118c82c84b126f97d549223c10ad07f4e98af912385d23b1a6e716925855a247b16effe92773315241ac951cdfefdfac0ed16467f6";
      privateKey = "00a2b6442a37f8a3764aeff4011a4c422b389a1e509669c43f279c8b7e32d80c3a";
      output = "00000000ffffffff00000000ffffffff00000000ffffffff00000000ffffffff";
      result = "valid";
      flags = [];
    },
    {
      tcId = 9;
      comment = "edge case for shared secret";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004ca03ff8e99e269576cf7564545c89268eb415ff45778732529fa5997cc2b230950d6b84b729bc07f9b2d92754281cdc0d289d2453385aef77e4bdc69bf155c5f";
      privateKey = "00a2b6442a37f8a3764aeff4011a4c422b389a1e509669c43f279c8b7e32d80c3a";
      output = "000003ffffff0000003ffffff0000003ffffff0000003ffffff0000004000000";
      result = "valid";
      flags = [];
    },
    {
      tcId = 10;
      comment = "edge case for shared secret";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000451be66137e39bbf35a91c6db5ba6919ff471d885ca94462eaaa65b1eac366baa5910de70b6e09e97aa00621ef18f2801719b199b3e7769fdab2bd909b2f340d7";
      privateKey = "00a2b6442a37f8a3764aeff4011a4c422b389a1e509669c43f279c8b7e32d80c3a";
      output = "0000ffff0000ffff0000ffff0000ffff0000ffff0000ffff0000ffff00010002";
      result = "valid";
      flags = [];
    },
    {
      tcId = 11;
      comment = "edge case for shared secret";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000423556564850c50fba51f1e64ef98378ef5c22feafa29499ca27600c473cace889d5679e917daa7f4c7899517d37826284f031de01a60bc813696414d04531a21";
      privateKey = "00a2b6442a37f8a3764aeff4011a4c422b389a1e509669c43f279c8b7e32d80c3a";
      output = "210c790573632359b1edb4302c117d8a132654692c3feeb7de3a86ac3f3b53f7";
      result = "valid";
      flags = [];
    },
    {
      tcId = 12;
      comment = "edge case for shared secret";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004ddbf807e22c56a19cf6c472829150350781034a5eddec365694d4bd5c865ead14e674127028c91d3394cac37293a866055d10f0f40a3706ad16b64fc9d5998bd";
      privateKey = "00a2b6442a37f8a3764aeff4011a4c422b389a1e509669c43f279c8b7e32d80c3a";
      output = "4218f20ae6c646b363db68605822fb14264ca8d2587fdd6fbc750d587e76a7ee";
      result = "valid";
      flags = [];
    },
    {
      tcId = 13;
      comment = "edge case for shared secret";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004595e46ee7c2d7183ff2ea760ffd8472fb834ec89c08b6ef48ff92b44a13a6e1ae563e23953c97c26441323d2500c84e8cee04c15d4d5d2cc458703d1f2d02d31";
      privateKey = "00a2b6442a37f8a3764aeff4011a4c422b389a1e509669c43f279c8b7e32d80c3a";
      output = "7fff0001fffc0007fff0001fffc0007fff0001fffc0007fff0001fffc0007fff";
      result = "valid";
      flags = [];
    },
    {
      tcId = 14;
      comment = "edge case for shared secret";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004e426e2f5108333117587975f18d8cc078d41e56b7d6b82f585d75b0d73479ffd75800fd41236a56034bed9abc55d82cf059a14d63c07cd0750931714731a1ca1";
      privateKey = "00a2b6442a37f8a3764aeff4011a4c422b389a1e509669c43f279c8b7e32d80c3a";
      output = "8000000000000000000000000000000000000000000000000000000000000000";
      result = "valid";
      flags = [];
    },
    {
      tcId = 15;
      comment = "edge case for shared secret";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004e1c7076caf26010b1767f1a9c4156b5b4236368d5d90dece3441b734e8684ee6b3534c3c54e614e594dce6ca438b87c424c8e80f8fae226bbdf50e4906c13f6b";
      privateKey = "00a2b6442a37f8a3764aeff4011a4c422b389a1e509669c43f279c8b7e32d80c3a";
      output = "8000003ffffff0000007fffffe000000ffffffc000001ffffff8000004000001";
      result = "valid";
      flags = [];
    },
    {
      tcId = 16;
      comment = "edge case for shared secret";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004663cea1063c9916b75e85fc815d8a2370ec0a02aceef3db022e395db8b03bf3f188787f4047dc106807526502c7ae880e471c929b92e2384489c8070b5bcc109";
      privateKey = "00a2b6442a37f8a3764aeff4011a4c422b389a1e509669c43f279c8b7e32d80c3a";
      output = "ff00000001fffffffc00000007fffffff00000001fffffffc000000080000000";
      result = "valid";
      flags = [];
    },
    {
      tcId = 17;
      comment = "edge case for shared secret";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000424175c078e305d3139e5dab727a6ab8587b26daa470a529a23c10585cb56c038bf1f2b937ae074ff94b15f5cb5e60eb5d32afba2077539db794294bcaab71a81";
      privateKey = "00a2b6442a37f8a3764aeff4011a4c422b389a1e509669c43f279c8b7e32d80c3a";
      output = "ffff00000003fffffff00000003fffffff00000003fffffff00000003fffffff";
      result = "valid";
      flags = [];
    },
    {
      tcId = 18;
      comment = "edge case for shared secret";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004008d71c712dd95881cd1400dbe7683acbd8e269d25261b08f1f491b45e3b5621778182a24198b0f23502d06e24c45122e1f420af48dc1e17b1ea923386a33062";
      privateKey = "00a2b6442a37f8a3764aeff4011a4c422b389a1e509669c43f279c8b7e32d80c3a";
      output = "ffffffff00000000000000ffffffffffffff0000000000000100000000000000";
      result = "valid";
      flags = [];
    },
    {
      tcId = 19;
      comment = "y-coordinate of the public key has many trailing 1's";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000456baf1d72606c7af5a5fa108620b0839e2c7dd40b832ef847e5b64c86efe1aa563e586a667a65bbb5692500df1ff8403736838b30ea9791d9d390e3dc6689e2c";
      privateKey = "00a2b6442a37f8a3764aeff4011a4c422b389a1e509669c43f279c8b7e32d80c3a";
      output = "800000000000000000000000009fa2f1ffffffffffffffffffffffffffffffff";
      result = "valid";
      flags = [];
    },
    {
      tcId = 20;
      comment = "y-coordinate of the public key is small";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200045e4c2cf1320ec84ef8920867b409a9a91d2dd008216a282e36bd84e884726fa05a5e4af11cf63ceaaa42a6dc9e4ccb394852cf84284e8d2627572fbf22c0ba88";
      privateKey = "00a2b6442a37f8a3764aeff4011a4c422b389a1e509669c43f279c8b7e32d80c3a";
      output = "80000000000000000000000000a3037effffffffffffffffffffffffffffffff";
      result = "valid";
      flags = [];
    },
    {
      tcId = 21;
      comment = "y-coordinate of the public key is small";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000402a30c2fabc87e6730625dec2f0d03894387b7f743ce69c47351ebe5ee98a48307eb78d38770fea1a44f4da72c26f85b17f3501a4f9394fe29856ccbf15fd284";
      privateKey = "00a2b6442a37f8a3764aeff4011a4c422b389a1e509669c43f279c8b7e32d80c3a";
      output = "8000000000000000000000000124dcb0ffffffffffffffffffffffffffffffff";
      result = "valid";
      flags = [];
    },
    {
      tcId = 22;
      comment = "y-coordinate of the public key is large";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200045e4c2cf1320ec84ef8920867b409a9a91d2dd008216a282e36bd84e884726fa0a5a1b50ee309c31555bd592361b334c6b7ad307bd7b172d9d8a8d03fdd3f41a7";
      privateKey = "00a2b6442a37f8a3764aeff4011a4c422b389a1e509669c43f279c8b7e32d80c3a";
      output = "80000000000000000000000000a3037effffffffffffffffffffffffffffffff";
      result = "valid";
      flags = [];
    },
    {
      tcId = 23;
      comment = "y-coordinate of the public key is large";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000402a30c2fabc87e6730625dec2f0d03894387b7f743ce69c47351ebe5ee98a483f814872c788f015e5bb0b258d3d907a4e80cafe5b06c6b01d67a93330ea029ab";
      privateKey = "00a2b6442a37f8a3764aeff4011a4c422b389a1e509669c43f279c8b7e32d80c3a";
      output = "8000000000000000000000000124dcb0ffffffffffffffffffffffffffffffff";
      result = "valid";
      flags = [];
    },
    {
      tcId = 24;
      comment = "y-coordinate of the public key has many trailing 0's";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200045450cace04386adc54a14350793e83bdc5f265d6c29287ecd07f791ad2784c4cebd3c24451322334d8d51033e9d34b6bb592b1995d07867863d1044bd59d7501";
      privateKey = "00a2b6442a37f8a3764aeff4011a4c422b389a1e509669c43f279c8b7e32d80c3a";
      output = "80000000000000000000000001126b54ffffffffffffffffffffffffffffffff";
      result = "valid";
      flags = [];
    },
    {
      tcId = 25;
      comment = "edge cases for ephemeral key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000400000000000000000000000000000000000000000000000000000000000000014218f20ae6c646b363db68605822fb14264ca8d2587fdd6fbc750d587e76a7ee";
      privateKey = "2bc15cf3981eab61e594ebf591290a045ca9326a8d3dd49f3de1190d39270bb8";
      output = "12c2ad36a59fda5ac4f7e97ff611728d0748ac359fca9b12f6d4f43519516487";
      result = "valid";
      flags = [];
    },
    {
      tcId = 26;
      comment = "edge cases for ephemeral key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004000000000000000000000000000000000000000000000000000000000000000266fbe727b2ba09e09f5a98d70a5efce8424c5fa425bbda1c511f860657b8535e";
      privateKey = "2bc15cf3981eab61e594ebf591290a045ca9326a8d3dd49f3de1190d39270bb8";
      output = "45aa9666757815e9974140d1b57191c92c588f6e5681131e0df9b3d241831ad4";
      result = "valid";
      flags = [];
    },
    {
      tcId = 27;
      comment = "edge cases for ephemeral key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000400000000000000000000000000000000000000000000000000000000000000032f233395c8b07a3834a0e59bda43944b5df378852e560ebc0f22877e9f49bb4b";
      privateKey = "2bc15cf3981eab61e594ebf591290a045ca9326a8d3dd49f3de1190d39270bb8";
      output = "b90964c05e464c23acb747a4c83511e93007f7499b065c8e8eccec955d8731f4";
      result = "valid";
      flags = [];
    },
    {
      tcId = 28;
      comment = "edge cases for ephemeral key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000400000000000000000000000000000000ffffffffffffffffffffffffffffffff3db772ad92db8699ceac1a3c30e126b866c4fefe292cf0c1790e55cee8414f18";
      privateKey = "2bc15cf3981eab61e594ebf591290a045ca9326a8d3dd49f3de1190d39270bb8";
      output = "8163c9dce8356f1df72b698f2f04a14db0263a8402905eee87941b00d8d677f5";
      result = "valid";
      flags = [];
    },
    {
      tcId = 29;
      comment = "edge cases for ephemeral key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200040000000000000000ffffffffffffffff0000000000000000ffffffffffffffff31cf13671b574e313c35217566f18bd2c5f758c140d24e94e6a4fda7f4c7b12b";
      privateKey = "2bc15cf3981eab61e594ebf591290a045ca9326a8d3dd49f3de1190d39270bb8";
      output = "1a32749dcf047a7e06194ccb34d7c9538a16ddabeeede74bea5f7ef04979f7f7";
      result = "valid";
      flags = [];
    },
    {
      tcId = 30;
      comment = "edge cases for ephemeral key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000400000000ffffffff00000000ffffffff00000000ffffffff00000000ffffffff73b0886496aed70db371e2e49db640abba547e5e0c2763b73a0a42f84348a6b1";
      privateKey = "2bc15cf3981eab61e594ebf591290a045ca9326a8d3dd49f3de1190d39270bb8";
      output = "ab43917a64c1b010159643c18e2eb06d25eedae5b78d02fa9b3debacbf31b777";
      result = "valid";
      flags = [];
    },
    {
      tcId = 31;
      comment = "edge cases for ephemeral key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004000003ffffff0000003ffffff0000003ffffff0000003ffffff00000040000000f4d81575c8e328285633ccfd8623f04dd4ed61e187b3a6d7eac553aede7f850";
      privateKey = "2bc15cf3981eab61e594ebf591290a045ca9326a8d3dd49f3de1190d39270bb8";
      output = "1648321c706651adf06643fc4ae06041dce64a82632ad44128061216cc9827ff";
      result = "valid";
      flags = [];
    },
    {
      tcId = 32;
      comment = "edge cases for ephemeral key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200040000ffff0000ffff0000ffff0000ffff0000ffff0000ffff0000ffff0001000242217b7059b3ddebc68e95443f6c109369e1f9323dd24852ac7612996b6e5601";
      privateKey = "2bc15cf3981eab61e594ebf591290a045ca9326a8d3dd49f3de1190d39270bb8";
      output = "fb866b2e4b1f9ed6b37847fc80a19a52e1e91b75d713b0d4f6b995d2d3c75cfe";
      result = "valid";
      flags = [];
    },
    {
      tcId = 33;
      comment = "edge cases for ephemeral key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004210c790573632359b1edb4302c117d8a132654692c3feeb7de3a86ac3f3b53f75f450dbbf718a4f6582d7af83953170b3037fb81a450a5ca5acbec74ad6cac89";
      privateKey = "2bc15cf3981eab61e594ebf591290a045ca9326a8d3dd49f3de1190d39270bb8";
      output = "1908ae936f53b9a8a2d09707ae414084090b175365401425479b10b8c3e8d1ba";
      result = "valid";
      flags = [];
    },
    {
      tcId = 34;
      comment = "edge cases for ephemeral key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200044218f20ae6c646b363db68605822fb14264ca8d2587fdd6fbc750d587e76a7ee37269a64bbcf3a3f227631c7a8ce532c77245a1c0db4343f16aa1d339fd2591a";
      privateKey = "2bc15cf3981eab61e594ebf591290a045ca9326a8d3dd49f3de1190d39270bb8";
      output = "5e13b3dc04e33f18d1286c606cb0191785f694e82e17796145c9e7b49bc2af58";
      result = "valid";
      flags = [];
    },
    {
      tcId = 35;
      comment = "edge cases for ephemeral key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200047fff0001fffc0007fff0001fffc0007fff0001fffc0007fff0001fffc0007fff4b66003c7482d0f2fd7b1cb2b0b7078cd199f2208fc37eb2ef286ccb2f1224e7";
      privateKey = "2bc15cf3981eab61e594ebf591290a045ca9326a8d3dd49f3de1190d39270bb8";
      output = "3135a6283b97e7537a8bc208a355c2a854b8ee6e4227206730e6d725da044dee";
      result = "valid";
      flags = [];
    },
    {
      tcId = 36;
      comment = "edge cases for ephemeral key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004800000000000000000000000000000000000000000000000000000000000000069d3cd0c70f1484d4b3bbbd680679ef477a22a07df085634f117c41c08bf1230";
      privateKey = "2bc15cf3981eab61e594ebf591290a045ca9326a8d3dd49f3de1190d39270bb8";
      output = "62959089a7ed477c22cb4f1c7787327318fccca25e5aa3e44688a282931ab049";
      result = "valid";
      flags = [];
    },
    {
      tcId = 37;
      comment = "edge cases for ephemeral key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200048000003ffffff0000007fffffe000000ffffffc000001ffffff800000400000130f69b6e95a3303214a73ad982a1f3ee169d7ecf958de7b0bca8a9ffa3b8e8b3";
      privateKey = "2bc15cf3981eab61e594ebf591290a045ca9326a8d3dd49f3de1190d39270bb8";
      output = "04fda5c00a396fad6b809a8843de573e86b0403d644995c83313da51fb1f5880";
      result = "valid";
      flags = [];
    },
    {
      tcId = 38;
      comment = "edge cases for ephemeral key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004ff00000001fffffffc00000007fffffff00000001fffffffc00000008000000056951ead861aa8ec7a314fcd54f905bd92c910786375eb7ee5f3a55f8aa87884";
      privateKey = "2bc15cf3981eab61e594ebf591290a045ca9326a8d3dd49f3de1190d39270bb8";
      output = "bbd9937bb51d27f94ecaea29717df789afeac4414e3ef27bb2e6fa7259182e59";
      result = "valid";
      flags = [];
    },
    {
      tcId = 39;
      comment = "edge cases for ephemeral key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004ffff00000003fffffff00000003fffffff00000003fffffff00000003fffffff63a88b2e0c8987c6310cf81d0c935f00213f98a3dad2f43c8128fa313a90d55b";
      privateKey = "2bc15cf3981eab61e594ebf591290a045ca9326a8d3dd49f3de1190d39270bb8";
      output = "bbd9d305b99ff3db56f77fea9e89f32260ee7326040067ce05dd15e0dcc13ed8";
      result = "valid";
      flags = [];
    },
    {
      tcId = 40;
      comment = "edge cases for ephemeral key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004ffffffff00000000000000ffffffffffffff000000000000010000000000000066a4456ca6d4054d13b209f6d262e6057ad712566f46e9e238e894deebe3d3aa";
      privateKey = "2bc15cf3981eab61e594ebf591290a045ca9326a8d3dd49f3de1190d39270bb8";
      output = "4ffb2c7962e32d5365f98f66be6286724d40d5f0333ba4fc943c0f0f06cdbb1f";
      result = "valid";
      flags = [];
    },
    {
      tcId = 41;
      comment = "edge cases for ephemeral key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004800000000000000000000000009fa2f1ffffffffffffffffffffffffffffffff07ed353c9f1039edcc9cc5336c034dc131a4087692c2e56bc1dd1904e3ffffff";
      privateKey = "2bc15cf3981eab61e594ebf591290a045ca9326a8d3dd49f3de1190d39270bb8";
      output = "7c07b199b6a62e7ac646c7e1dee94aca55de1a97251ddf92fcd4fe0145b40f12";
      result = "valid";
      flags = [];
    },
    {
      tcId = 42;
      comment = "edge cases for ephemeral key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000480000000000000000000000000a3037effffffffffffffffffffffffffffffff0000031a6bf344b86730ac5c54a7751aefdba135759b9d535ca64111f298a38d";
      privateKey = "2bc15cf3981eab61e594ebf591290a045ca9326a8d3dd49f3de1190d39270bb8";
      output = "5206c3de46949b9da160295ee0aa142fe3e6629cc25e2d671e582e30ff875082";
      result = "valid";
      flags = [];
    },
    {
      tcId = 43;
      comment = "edge cases for ephemeral key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000480000000000000000000000000a3037efffffffffffffffffffffffffffffffffffffce5940cbb4798cf53a3ab588ae510245eca8a6462aca359beed0d6758a2";
      privateKey = "2bc15cf3981eab61e594ebf591290a045ca9326a8d3dd49f3de1190d39270bb8";
      output = "5206c3de46949b9da160295ee0aa142fe3e6629cc25e2d671e582e30ff875082";
      result = "valid";
      flags = [];
    },
    {
      tcId = 44;
      comment = "edge cases for ephemeral key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000480000000000000000000000001126b54ffffffffffffffffffffffffffffffff4106a369068d454ea4b9c3ac6177f87fc8fd3aa240b2ccb4882bdccbd4000000";
      privateKey = "2bc15cf3981eab61e594ebf591290a045ca9326a8d3dd49f3de1190d39270bb8";
      output = "e59ddc7646e4aef0623c71c486f24d5d32f7257ef3dab8fa524b394eae19ebe1";
      result = "valid";
      flags = [];
    },
    {
      tcId = 45;
      comment = "edge cases for ephemeral key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200048000000000000000000000000124dcb0ffffffffffffffffffffffffffffffff0000013bc6f08431e729ed2863f2f4ac8a30279695c8109c340a39fa86f451cd";
      privateKey = "2bc15cf3981eab61e594ebf591290a045ca9326a8d3dd49f3de1190d39270bb8";
      output = "8a8c18b78e1b1fcfd22ee18b4a3a9f391a3fdf15408fb7f8c1dba33c271dbd2f";
      result = "valid";
      flags = [];
    },
    {
      tcId = 46;
      comment = "edge cases for ephemeral key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200048000000000000000000000000124dcb0fffffffffffffffffffffffffffffffffffffec4390f7bce18d612d79c0d0b5375cfd8696a37ef63cbf5c604790baa62";
      privateKey = "2bc15cf3981eab61e594ebf591290a045ca9326a8d3dd49f3de1190d39270bb8";
      output = "8a8c18b78e1b1fcfd22ee18b4a3a9f391a3fdf15408fb7f8c1dba33c271dbd2f";
      result = "valid";
      flags = [];
    },
    {
      tcId = 47;
      comment = "point with coordinate x = 1";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000400000000000000000000000000000000000000000000000000000000000000014218f20ae6c646b363db68605822fb14264ca8d2587fdd6fbc750d587e76a7ee";
      privateKey = "00938f3dbe37135cd8c8c48a676b28b2334b72a3f09814c8efb6a451be00c93d23";
      output = "f362289d3a803d568a0a42767070d793bd70891fb5e03b01413b6d3f1eb52ff8";
      result = "valid";
      flags = [];
    },
    {
      tcId = 48;
      comment = "point with coordinate x = 1";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000422b961ed14f6368903feeb42d63d37bd11302893e8ff64c1a8e7fd0731439bb6981a712063bfba34d177412bb284c4361953decf29bbde0185a58bd02f3be430";
      privateKey = "00938f3dbe37135cd8c8c48a676b28b2334b72a3f09814c8efb6a451be00c93d23";
      output = "bae229e6d001fd47741aeee860048a855432076fe270f632f46d1301022b6452";
      result = "valid";
      flags = [];
    },
    {
      tcId = 49;
      comment = "point with coordinate x = 1";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200042f9245bac6fa959b4f02773e21411f48b74f9806fe4d32e36bdf9ab02814f3535745da334d06bafe2d83c235f0c7a29f8f042722ec34e53aa96d97a331a733ef";
      privateKey = "00938f3dbe37135cd8c8c48a676b28b2334b72a3f09814c8efb6a451be00c93d23";
      output = "e90b9e81bd013d349f70fde1b51bad04c581011c68f0c2053ac91dc8187abb9a";
      result = "valid";
      flags = [];
    },
    {
      tcId = 50;
      comment = "point with coordinate x = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200041e396a2525bc3fb00af898b06bb87c1d674fc0662b867ffac08eb0dba2146c21a8b8429f11803649be34ae515c173a43ba74f13ebbd0e261011c162e573599b4";
      privateKey = "00938f3dbe37135cd8c8c48a676b28b2334b72a3f09814c8efb6a451be00c93d23";
      output = "de7cde6b5806a325da845e9a191e18377868636e5ef1f5fa08e756c02d6fd4de";
      result = "valid";
      flags = [];
    },
    {
      tcId = 51;
      comment = "point with coordinate x = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004452158303b37ff9bebca720ea1085efaa4f859db950a99fccd9d2d179273abb108a9083f8075005943bd68c566ec1f2f067664da9212ec1833799bba881d8e8b";
      privateKey = "00938f3dbe37135cd8c8c48a676b28b2334b72a3f09814c8efb6a451be00c93d23";
      output = "96328fa84038a63c817ef7cd13b79794a2db467dd3bd8769df782adace3c82eb";
      result = "valid";
      flags = [];
    },
    {
      tcId = 52;
      comment = "point with coordinate x = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200045a2a401666e0f1978c6f30aec53fee58b4c4f75e7c1a00156a36ad27c0a5a295658577e657223b8c20c826243b5ae2ca0f6148c2529ec6d60ec260916641d8fa";
      privateKey = "00938f3dbe37135cd8c8c48a676b28b2334b72a3f09814c8efb6a451be00c93d23";
      output = "b6699fe9a18c2d0d14e95405133e000b167dc2e5451dcdf09ade49ba0db213eb";
      result = "valid";
      flags = [];
    },
    {
      tcId = 53;
      comment = "point with coordinate x = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004b2cd039500bcf460e24fd80383b60eb81a56f467077e768231553a0fa0dafcc81d4a1b8fd88b3b23f2d503285c9d72bba448c15bc016c620f707599a129546ae";
      privateKey = "00938f3dbe37135cd8c8c48a676b28b2334b72a3f09814c8efb6a451be00c93d23";
      output = "7a23aee5b0fed16638f0e2eb05fba1fd44167d496ebeb274db218593b4ea201c";
      result = "valid";
      flags = [];
    },
    {
      tcId = 54;
      comment = "point with coordinate x = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000403cf500d838c9fcb97d8ddba2466ec6e474498315d6c2a43110308f22459d49b07875aaed2edabed842fb1608ca706bd39d6021a60bc270947c12053c9dbafa1";
      privateKey = "00938f3dbe37135cd8c8c48a676b28b2334b72a3f09814c8efb6a451be00c93d23";
      output = "d8aef4c5c8b60886d7f33cdd2390c21311e69f606dc777dc41c43a461995c315";
      result = "valid";
      flags = [];
    },
    {
      tcId = 55;
      comment = "point with coordinate x = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200040b6f2cb62954f994564e1419cf9d5982ec6511e7fa7e17f9685e019949906df2fb429b0554a25a4a0c510270d3cc73e6cfec9bc2e63cbd2b7aa0db98e1f330cd";
      privateKey = "00938f3dbe37135cd8c8c48a676b28b2334b72a3f09814c8efb6a451be00c93d23";
      output = "4c0892bacd983ec0013f477d94d8fb850585eff2197b53d566a9926bd898d948";
      result = "valid";
      flags = [];
    },
    {
      tcId = 56;
      comment = "point with coordinate x = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200043025b046f4a70e06330f3b14c4fa3ec1e04fe19ed8c90352dc6ff5627ca7b3b3a264d5ad9f06d8487430f654f7dd8f6735fc836ef48d6d4d4996a9c20af320ee";
      privateKey = "00938f3dbe37135cd8c8c48a676b28b2334b72a3f09814c8efb6a451be00c93d23";
      output = "6e2119935a5c2521182a701d5a13215a7dfb8a1f001b3887e8ae51bf259b180b";
      result = "valid";
      flags = [];
    },
    {
      tcId = 57;
      comment = "point with coordinate x = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200047d3b8428c80299a4ff1d96ed75a5a44629fd0313c097c478e55f2fa0ae45b691bb4963b5cc095abe5dcfe98399317fd5ad59f3674c07063a9123a2aa24814585";
      privateKey = "00938f3dbe37135cd8c8c48a676b28b2334b72a3f09814c8efb6a451be00c93d23";
      output = "2b8b0d4eee83d1c4b1f2a67144fef78e7faa86e6d5d6a8b72b359c4f373adb71";
      result = "valid";
      flags = [];
    },
    {
      tcId = 58;
      comment = "point with coordinate x = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004fb77841884d30fa5b73ad21d0a5ae40c53a9faa5d325699436338cee4ba213697bd732d47c86dcd63691097b1999c9f0a660a9c3d613671039cf1763467d8140";
      privateKey = "00938f3dbe37135cd8c8c48a676b28b2334b72a3f09814c8efb6a451be00c93d23";
      output = "58dbf6ad5e791956e8635427252cf5e518bd10ed2a936a1f3747ba4ea7983274";
      result = "valid";
      flags = [];
    },
    {
      tcId = 59;
      comment = "point with coordinate x = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200049aef51383a556cf317fe68bea6a85a254825ec5b3f1358aea209a43ca38c66351aee1a91aeb2a4dcad739722f44c437dfd32731f0862dd751b80bd88d0969bd6";
      privateKey = "00938f3dbe37135cd8c8c48a676b28b2334b72a3f09814c8efb6a451be00c93d23";
      output = "123b494058dec32fb74fdeb1aa9a4d52bfddf2d90b9b46edbcf4cc95ea736251";
      result = "valid";
      flags = [];
    },
    {
      tcId = 60;
      comment = "point with coordinate x = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200042769df335132f2025e64104804678737860ee66e07e675f720e7d4ef5c38a2c281f80c3b6d47db0a412e6edd3c5bf48accac1497b59e13b15dfc2cd15e6ae47a";
      privateKey = "00938f3dbe37135cd8c8c48a676b28b2334b72a3f09814c8efb6a451be00c93d23";
      output = "af4b79efc450630b8c027697e2376f14842babad81bd68592c37279a9fc41ab6";
      result = "valid";
      flags = [];
    },
    {
      tcId = 61;
      comment = "point with coordinate x = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000461b8c48750735a6b5cc45b691906e5cc292d5969bb1d6ff90ff446d94811ce7c2853977419cba2b92cc574abce030473eb008350566d7eaa24cb9daad70710ed";
      privateKey = "00938f3dbe37135cd8c8c48a676b28b2334b72a3f09814c8efb6a451be00c93d23";
      output = "08b4326b42d817e2f8bc09f26f49b720afcede10236d0a25e7e9518eac96e3bd";
      result = "valid";
      flags = [];
    },
    {
      tcId = 62;
      comment = "point with coordinate x = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000416eeabc802e3409b7c7b3e7607b7166243fc1746294948fc8123b399cfb89962fcbf0bf8a5191ce958dd5ea3ab633c090d1259fbd9a977fde0cc212d5b3b9858";
      privateKey = "00938f3dbe37135cd8c8c48a676b28b2334b72a3f09814c8efb6a451be00c93d23";
      output = "52505bfea9d066f0aa9008e8382382c7d48460d76f2962e509482b6eb56e0ac5";
      result = "valid";
      flags = [];
    },
    {
      tcId = 63;
      comment = "point with coordinate x = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000463b1d99491b46cee7e186a243bce1cc386297571850a10d9a2962d769a411c616345e28532cac39960a2f12bbd03205b77464a80a0416446e6ff85851a009f64";
      privateKey = "00938f3dbe37135cd8c8c48a676b28b2334b72a3f09814c8efb6a451be00c93d23";
      output = "1e6464f78fbedecd821a4fa04d7e8f1364d324be24d12212994683fc2b6bb1a2";
      result = "valid";
      flags = [];
    },
    {
      tcId = 64;
      comment = "point with coordinate x = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000475c78ae9c94613dd051eed7dd7df66a081cd0ac27cf65e4ef0ea826276c5efcfa92ed1c4ffbb84301f5bb1c6bc9e14c6e6dad1e04a287826528478f9ae1609c2";
      privateKey = "00938f3dbe37135cd8c8c48a676b28b2334b72a3f09814c8efb6a451be00c93d23";
      output = "b4fcb72d1f81db211dd94039a1368c2c4effd1efe832f1a1db2dae5253c27303";
      result = "valid";
      flags = [];
    },
    {
      tcId = 65;
      comment = "point with coordinate x = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004072838e4f972d4a65d258dbc32a530fde2e873537b5a4aa707cf81cecc0f7ff12e4b608b9e321c9db72cf4d9ba4b3c2c13756040d77af6bd251bc24cf18676f1";
      privateKey = "00938f3dbe37135cd8c8c48a676b28b2334b72a3f09814c8efb6a451be00c93d23";
      output = "f4f4926b6f64e47abeadbdc5a8a67706a42e00774e1cc5afda7d57ced6423b39";
      result = "valid";
      flags = [];
    },
    {
      tcId = 66;
      comment = "point with coordinate x = 1 in precomputation or right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200044301f54b3592d1ea2a40989c94261d2b1d1fe297ed6ed64125ee241de05d004bc79014f156e9b7bfb36b8ad2d66d55f3a753829a9ddb86055bb9166dd3aff457";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "fdc15a26abbade3416e1201a6d737128a2f897f0d88108645453a1b3ddd05688";
      result = "valid";
      flags = [];
    },
    {
      tcId = 67;
      comment = "point with coordinate x = 1 in precomputation or right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000436b0f66bf5f9fd4b2df9cdae2af873a075c55497d7fec4737a7c9643c2c76fe5da9f7287b3cd4e5f05b9a1a4f64e8a8d96c316e452594d02a4592a2107ece90b";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "e36348e3a464bc518384806c548e156edd994cb6946473c265a24914d5559f1c";
      result = "valid";
      flags = [];
    },
    {
      tcId = 68;
      comment = "point with coordinate x = 1 in precomputation or right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000482abb58afb62d261878bdee12664df1499b824f1d60fb02811642cb02f4aff5d30719835d96f32dc03c49d815ffa21285733137f507ce316cec65ca562ce2ad0";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "7d65684bdce4ac95db002fba350dc89d0d0fc9e12260d01868543f2a6c8c5b8d";
      result = "valid";
      flags = [];
    },
    {
      tcId = 69;
      comment = "point with coordinate x = 1 in precomputation or right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200047de7b7cf5c5ff4240daf31a50ac6cf6b169aad07d2c5936c73b83ee3987e22a1940c1bd78e4be6692585c99dc92b47671e2ccbcf12a9a9854c6607f98213c108";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "6ec6ba2374ab0a9ae663f3f73671158aaabac3ac689d6c2702ebdf4186597a85";
      result = "valid";
      flags = [];
    },
    {
      tcId = 70;
      comment = "point with coordinate x = 1 in precomputation or right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000406fa93527294c8533aa401ce4e6c8aeb05a6921bc48798a8e20a0f84a5085af4ec4828f8394d22de43043117b8595fb113245f7285cb35439389e8547a105039";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "6d6e87787d0a947ecfbf7962142fde8ff9b590e472c0c46bbc5d39020e4f78a7";
      result = "valid";
      flags = [];
    },
    {
      tcId = 71;
      comment = "point with coordinate x = 1 in precomputation or right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200048a4f625210b448dc846ad2399b31cd1bc3f1788c7bed69cc1cb7aac8ab28d5393007c6f11f3e248de651c6622de308ee5576be84ef1ed8ed91fd244f14fc2053";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "56ea4382f8e1abfcb211989f500676449abcebfe2cd2204dd8923deb530a6c7b";
      result = "valid";
      flags = [];
    },
    {
      tcId = 72;
      comment = "point with coordinate x = 1 in right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004885e452cbb0e4b2a9768b7596c153198a922dabbb8d0ca1dc3faf4f097f09113be9aaa630918d5056053ecf7388f448b912d9ccfbed80d7ca23c0e7991a34901";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "2c362c27b3107ea8a042c05cc50c4a8ddaae8cdc33d058492951a03f8d8f8194";
      result = "valid";
      flags = [];
    },
    {
      tcId = 73;
      comment = "point with coordinate x = 1 in right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004e226df1fcf7c137a41c920ff74d6204faa2093eeffc4a9ee0a23fb2e994041c3457107442cc4b3af631c4dfb5f53e2c5608bed04ff6653b771f7cd4670f81034";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "0188da289ce8974a4f44520960fae8b353750aca789272e9f90d1215bacdd870";
      result = "valid";
      flags = [];
    },
    {
      tcId = 74;
      comment = "point with coordinate x = 1 in right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004f53ead9575eebba3b0eb0d033acb7e99388e8590b4ad2db5ea4f6bd9bde16995b5f3ab15f973ca9e3aa9dfe2914eebbd2e11010b455513907908800396fb9d1a";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "f78bd7ff899c81b866be17c0a94bec592838d78d1f0c0cf532829b6c464c28ac";
      result = "valid";
      flags = [];
    },
    {
      tcId = 75;
      comment = "point with coordinate x = 1 in right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004882773ec7e10605c8f9e2e3b8700943be26bcc4c9d1fedf2bdcfb36994f23c7f8e5d05b2fdd2954b6188736ebe3f5646602a58d978b716b5304ea56777691db3";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "99f6151fba28067eac73354920fcc1fa17fea63225a583323cb6c3d4054ecaca";
      result = "valid";
      flags = [];
    },
    {
      tcId = 76;
      comment = "point with coordinate x = 1 in right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004a60b6458256b38d4644451b490bd357feade7bb6b8453c1fc89794d5a45f768d81eee90548a59e5d2cecd72d4b0b5e6574d65a9d837c7c590d1d125ee37c4d51";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "68ca39de0cec2297529f56876bc3de7be370f300e87c2b09cdbb5120382d6977";
      result = "valid";
      flags = [];
    },
    {
      tcId = 77;
      comment = "point with coordinate y = 1";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004cbb0deab125754f1fdb2038b0434ed9cb3fb53ab735391129994a535d925f6730000000000000000000000000000000000000000000000000000000000000001";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "af306c993dee0dcfc441ebe53360b569e21f186052db8197f4a124fa77b98148";
      result = "valid";
      flags = [];
    },
    {
      tcId = 78;
      comment = "point with coordinate y = 1";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000424800deac3fe4c765b6dec80ea299d771ada4f30e4e156b3acb720dba37394715fe4c64bb0648e26d05cb9cc98ac86d4e97b8bf12f92b9b2fdc3aecd8ea6648b";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "aa7fc9fe60445eac2451ec24c1a44909842fa14025f2a1d3dd7f31019f962be5";
      result = "valid";
      flags = [];
    },
    {
      tcId = 79;
      comment = "point with coordinate y = 1";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200048f33652f5bda2c32953ebf2d2eca95e05b17c8ab7d99601bee445df844d46a369cf5ac007711bdbe5c0333dc0c0636a64823ee48019464940d1f27e05c4208de";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "082a43a8417782a795c8d4c70f43edcabbc245a8820ac01be90c1acf0343ba91";
      result = "valid";
      flags = [];
    },
    {
      tcId = 80;
      comment = "point with coordinate y = 1";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004146d3b65add9f54ccca28533c88e2cbc63f7443e1658783ab41f8ef97c2a10b50000000000000000000000000000000000000000000000000000000000000001";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "70810b4780a63c860427d3a0269f6c9d3c2ea33494c50e58a20b9480034bc7a0";
      result = "valid";
      flags = [];
    },
    {
      tcId = 81;
      comment = "point with coordinate y = 1";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004b0344418a4504c07e7921ed9f00714b5d390e5cb5e793bb1465f73174f6c26fe5fe4c64bb0648e26d05cb9cc98ac86d4e97b8bf12f92b9b2fdc3aecd8ea6648b";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "a7d34ee25fbb354f8638d31850dab41e4b086886f7ed3f2d6e035bceb8cab8a0";
      result = "valid";
      flags = [];
    },
    {
      tcId = 82;
      comment = "point with coordinate y = 1";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200048a98c1bc6be75c5796be4b29dd885c3485e75e37b4ccac9b37251e67175ff0d69cf5ac007711bdbe5c0333dc0c0636a64823ee48019464940d1f27e05c4208de";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "3f09cbc12ed1701f59dd5aa83daef5e6676adf7fd235c53f69aeb5d5b67799e0";
      result = "valid";
      flags = [];
    },
    {
      tcId = 83;
      comment = "point with coordinate y = 1";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200041fe1e5ef3fceb5c135ab7741333ce5a6e80d68167653f6b2b24bcbcfaaaff5070000000000000000000000000000000000000000000000000000000000000001";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "e04e881f416bb5aa3796407aa5ffddf8e1b2446b185f700f6953468384faaf76";
      result = "valid";
      flags = [];
    },
    {
      tcId = 84;
      comment = "point with coordinate y = 1";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200042b4badfc97b16781bcfff4a525cf4dd31194cb03bca56d9b0ce96c0c0d2040c05fe4c64bb0648e26d05cb9cc98ac86d4e97b8bf12f92b9b2fdc3aecd8ea6648b";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "adace71f40006c04557540c2ed8102d830c7f638e2201efeb47d732da79f13d9";
      result = "valid";
      flags = [];
    },
    {
      tcId = 85;
      comment = "point with coordinate y = 1";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004e633d914383e7775d402f5a8f3ad0deb1f00d91ccd99f348da96839ea3cb9d529cf5ac007711bdbe5c0333dc0c0636a64823ee48019464940d1f27e05c4208de";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "b8cbf0968fb70d391059d090b30d1c4edcd2dad7abbf7aa4ad452f5a4644a7be";
      result = "valid";
      flags = [];
    },
    {
      tcId = 86;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004d1c1b509c9ddb76221a066a22a3c333fee5e1d2d1a4babde4a1d33ec247a7ea30162f954534eadb1b4ea95c57d40a10214e5b746ee6aa4194ed2b2012b72f97d";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "07257245da4bc26696e245531c7a97c2b529f1ca2d8c051626520e6b83d7faf2";
      result = "valid";
      flags = [];
    },
    {
      tcId = 87;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004755d8845e7b4fd270353f6999e97242224015527bf3f94cc2c693d1b6ba12298604f8174e3605b8f18bed3742b6871a8cffce006db31b8d7d836f50cfcda7d16";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "d6aa401b9ce17ecf7dd7b0861dfeb36bb1749d12533991e66c0d942281ae13ab";
      result = "valid";
      flags = [];
    },
    {
      tcId = 88;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004c6f9fc8644ba5c9ea9beb12ce2cb911c5487e8b1be91d5a168318f4ae44d66807bc337a1c82e3c5f7a2927987b8fae13627237d220fafb4013123bfbd95f0ba5";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "f43bfe4eccc24ebf6e36c5bcaca47b770c17bcb59ea788b15c74ae6c9dd055a1";
      result = "valid";
      flags = [];
    },
    {
      tcId = 89;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004d3179fce5781d0c49ce8480a811f6f08e3f123d9f6010fbf619b5d868a8ea833ddf9a666bf0015b20e4912f70f655ef21b82087596aa1e2f1e2865350d159185";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "009bc3abb3cf0aca214f0e8db5088d520b3d4aadb1d44c4a2be7f031461c9420";
      result = "valid";
      flags = [];
    },
    {
      tcId = 90;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200049e098095463c91ac7107a920ccb276d45e1f7240ef2b93b957ee09393d32e001503af4a2e3b26279564fed8e772a043e75630e4e3859976ede88ffcf16f5ca71";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "8bcb07a3d0fa82af60c88a8d67810ebca0ea27548384e96d3483310212219312";
      result = "valid";
      flags = [];
    },
    {
      tcId = 91;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004bf3034a9935182da362570315011544ac2ce8a9c22777c2fc767ac9c5c0daeebcf333562f3e018892374353674de8490fc9d30426598eb600779154baf2aec17";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "a09ddc7cfe023acd9571ef0754010289c804678c043f900f2691dd801b942ed4";
      result = "valid";
      flags = [];
    },
    {
      tcId = 92;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004709c7179c2bb27ce3985ba42feb870f069dacead9294c80557be882fb57790481e6fe2c1a715163efaf86ea8b1e55ea5742d6b042e6cbf8acc69c99f8271a902";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "da98054d51ac9615e9d4f5ceda1f1bad40302ac11603431efec13ab50e32fcf2";
      result = "valid";
      flags = [];
    },
    {
      tcId = 93;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004264c00a2d92514a6dbe655de3c71a5740cec4fcb251aa48ca6745dbea6f5f7cfc1d5ee9fc3ce49fd4509d33c4dcfcc1a20a660529fa9ebd6e6afc3d5c84c72bb";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "d60795d8f310b155726534b8be3d0b8a7bc2ced468c6e64c8b9ae087b33ee00b";
      result = "valid";
      flags = [];
    },
    {
      tcId = 94;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004a12124606bcbbb33cecec7fc8d78b3897192ca851560c539e47dd276c63bd3c2f20a0ca618ba0131a2e373f31f73b3f55e9188d46fddbc6387e32aefb9f3ba12";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "675fef8f5680bf76220e91362613944099046b0ba07e5824e93f3e3cc2cc2758";
      result = "valid";
      flags = [];
    },
    {
      tcId = 95;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004244b7afe7f31289f9d6aaeb7f70d29a7b49a228c7bb202764aba94daaaa3332270c60975748f0c749a8b0f8fc1e222ddcbd3384f6d68f0b6b6ff679b435cdcb1";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "76b439f8ea7b42f11cd59e6d91b2d2a72577c185386b6af6639be8e3864a7f27";
      result = "valid";
      flags = [];
    },
    {
      tcId = 96;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200042ac29db2ebc4fa9473b42bd335a60226579cc186b2c676a3b01bc60e589616165aa9c0d1b240e6dd4211e3235425634b278ad88fede0337d5acf3136587d8413";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "56e63fa788121d5efa0ce3caf4605af18d48c631496cdfa862c43ecf5e5fc127";
      result = "valid";
      flags = [];
    },
    {
      tcId = 97;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004e62aee5205a8063e3ae401d53e9343001e55eb5f4e4d6b70e2b84159cf3157e64ba2e420cabc43b6e8e86590fc2383d17827dd99a60c211f190a74269100c141";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "cff3b5e19ed67e5111dd76e310a1f11d7f99a93fbe9cc5c6f3384086cacd1142";
      result = "valid";
      flags = [];
    },
    {
      tcId = 98;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000431dce6de741f10267f2e8f3d572a4f49be5fe52ff7bff3c3b4646f38076c06752702a515a9a50db1d86fd42aea0834daeb62be03d0cd9033f84b9c4b56a19f12";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "e29483884a74fb84f4601654885a0f574691394f064ea6937a846175ef081fc5";
      result = "valid";
      flags = [];
    },
    {
      tcId = 99;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200046518cd66b1d841e689d5dc6674c7cc7d964574d1490fff7906bd373494791599104277170692fa6bf2270580d56d1bc81b54f477d8ab6c3f5842650ac7176d71";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "9c6a4bcb2fc086aca8726d850fa79920214af4c151acea0fcf12a769ad1f3574";
      result = "valid";
      flags = [];
    },
    {
      tcId = 100;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004952a88ce31ad4cb086978e6c5621c3d8023b2c11418d6fd0dcef8de72123efc15d367688fde5e082f097855a0c0adc305dd6cf46f50ca75859bb243b70249605";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "34b7abc3f3e36e37e2d5728a870a293a16403146ca67ff91cbabeee2bb2e038b";
      result = "valid";
      flags = [];
    },
    {
      tcId = 101;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200042a43f33573b619719099cf54f6cccb28d16df3992239fadf79c7acb9c64f7af0f4d1d22af7187c8de1b992a4046c419b801cde57d638d30f2e1ac49353117a20";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "9bd1284f1bcb1934d483834cae41a77db28cd9553869384755b6983f4f3848a0";
      result = "valid";
      flags = [];
    },
    {
      tcId = 102;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200041b1b0c75408785e84727b0e55e4ba20d0f2599c4ed08482dc1f3b5df545691380162f954534eadb1b4ea95c57d40a10214e5b746ee6aa4194ed2b2012b72f97d";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "167e3db6a912ac6117644525911fc8872ed33b8e0bbd50073dd3c17a744e61e0";
      result = "valid";
      flags = [];
    },
    {
      tcId = 103;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200044dd1283bccd36cc3402f3a81e2e9b0d6a2b2b1debbbd44ffc1f179bd49cf0a7e604f8174e3605b8f18bed3742b6871a8cffce006db31b8d7d836f50cfcda7d16";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "7c3020e279cb5af14184b4653cc87c1ddd7f49cd31cd371ae813681dd6617d0e";
      result = "valid";
      flags = [];
    },
    {
      tcId = 104;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004a499dbf732e438be0eb084b9e6ad879dd7a2904bbb004b40027969a171f2d4267bc337a1c82e3c5f7a2927987b8fae13627237d220fafb4013123bfbd95f0ba5";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "acfdff566b8b55318869fa646f789f8036d40b90f0fc520ae2a5a27544f962c0";
      result = "valid";
      flags = [];
    },
    {
      tcId = 105;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004adcf0ffba9cb6ef0c8031c4291a434b18d78f42e45e62ba01fbe91f9273f0ad1ddf9a666bf0015b20e4912f70f655ef21b82087596aa1e2f1e2865350d159185";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "5c6b01cff4e6ce81a630238b5db3662e77fb88bffdde61443a7d8554ba001ef2";
      result = "valid";
      flags = [];
    },
    {
      tcId = 106;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000421712725d9806acf54d3a6c82bf93c0fe249268ca9f42eceac19e93a5eab8056503af4a2e3b26279564fed8e772a043e75630e4e3859976ede88ffcf16f5ca71";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "e7281d12b74b06eecb273ec3e0d8fe663e9ec1d5a50c2b6c68ec8b3693f23c4c";
      result = "valid";
      flags = [];
    },
    {
      tcId = 107;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200041e02176824bd31eabdce03a9403c7d3c2ac631f9b0e88d9a924701c1b2f29b85cf333562f3e018892374353674de8490fc9d30426598eb600779154baf2aec17";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "80643ed8b9052a2e746a26d9178fe2ccff35edbb81f60cd78004fb8d5f143aae";
      result = "valid";
      flags = [];
    },
    {
      tcId = 108;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000463e7a1af36d6b540a49276aac3fec9cb45ed6bab167c06b0419a77b91399f6181e6fe2c1a715163efaf86ea8b1e55ea5742d6b042e6cbf8acc69c99f8271a902";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "75873ac544ad69d3ddc5c9cffe384d275e9da2949d6982da4b990f8bf2b76474";
      result = "valid";
      flags = [];
    },
    {
      tcId = 109;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200041e265ab5b7f7199470e532653d2a7b9a8b728970b838137c9692ed0692897b2ac1d5ee9fc3ce49fd4509d33c4dcfcc1a20a660529fa9ebd6e6afc3d5c84c72bb";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "355c9faca29cf7cc968853ee29ffe62d1127fcc1dc57e9ddaf0e0f447146064e";
      result = "valid";
      flags = [];
    },
    {
      tcId = 110;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000454d2a4394c109fcbd3cb9886fec3add51ba4d2e44e1d5676e4b98f0c13655fc5f20a0ca618ba0131a2e373f31f73b3f55e9188d46fddbc6387e32aefb9f3ba12";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "fc175a5ef18595b69e45be2cda8ae00d9c8bdbefbcf7f692f91cefdc560e4722";
      result = "valid";
      flags = [];
    },
    {
      tcId = 111;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000493f1459207fb09c6f0a88c398ac80d1052a4cd33e7eef5687da99ab97c6024b770c60975748f0c749a8b0f8fc1e222ddcbd3384f6d68f0b6b6ff679b435cdcb1";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "46559146a93aae904dbcaaaa07e6cd1bb450f1b37c83929a994b45792333d5f6";
      result = "valid";
      flags = [];
    },
    {
      tcId = 112;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200041fa049a1892b679857c6dff08af19db70cbc99b6f2d7bc51a341fe79d1647f4a5aa9c0d1b240e6dd4211e3235425634b278ad88fede0337d5acf3136587d8413";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "c64b07119054a37961c0a177158256081b38b0087b307e0cad7e30d790ceb0ce";
      result = "valid";
      flags = [];
    },
    {
      tcId = 113;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000484e0b192d60abf531e828e887d366d869e1033a16e9c7f1167458c8134c10fba4ba2e420cabc43b6e8e86590fc2383d17827dd99a60c211f190a74269100c141";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "bea8cfc0bee8571ccf0c525654ef26d1fc782bb22deccf67ea4ea0803dc15daf";
      result = "valid";
      flags = [];
    },
    {
      tcId = 114;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200042f9707c67118724111efbbbbf06b623ab2ffd9259ddc354fcaaf81ba01f6fa7b2702a515a9a50db1d86fd42aea0834daeb62be03d0cd9033f84b9c4b56a19f12";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "60451da4adfe5bb393109069efdc84415ec8a2c429955cbf22a4340f8fc48936";
      result = "valid";
      flags = [];
    },
    {
      tcId = 115;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004ac1fbbe42293a9f9ae104ee2da0b0a9b3464d5d8b1e854df19d3c4456af8f9a6104277170692fa6bf2270580d56d1bc81b54f477d8ab6c3f5842650ac7176d71";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "d68e746f3d43feac5fd4898de943dc38205af7e2631ed732079bbfc8ab52511c";
      result = "valid";
      flags = [];
    },
    {
      tcId = 116;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004bae10cf93ff7b72d6ed98519602e9f03aa40303fa0674fb3ddee7d2db1c92bb25d367688fde5e082f097855a0c0adc305dd6cf46f50ca75859bb243b70249605";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "28daeaadc609386d770dff4c7120b2a87cab3e21fdb8a6e4dc1240a51d12e55c";
      result = "valid";
      flags = [];
    },
    {
      tcId = 117;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004edb4288cf5567673d50a1cd9e6bea45317823f30383f60d9bc3b9ee42ac29871f4d1d22af7187c8de1b992a4046c419b801cde57d638d30f2e1ac49353117a20";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "bb4110b734c8ef8a08bb6011acb35cbda9ae8e2ef6c4d0862576a68792667bb9";
      result = "valid";
      flags = [];
    },
    {
      tcId = 118;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000413233e80f59ac2b59737e87877782ab3027c490df8ac0bf3f3ef1633872eec540162f954534eadb1b4ea95c57d40a10214e5b746ee6aa4194ed2b2012b72f97d";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "e25c50037ca1913851b9758752659fb61c02d2a7c6b6aae29bda301907d99f5d";
      result = "valid";
      flags = [];
    },
    {
      tcId = 119;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200043cd14f7e4b779615bc7ccee47e7f2b07394bf8f98503263411a549264a8fcf19604f8174e3605b8f18bed3742b6871a8cffce006db31b8d7d836f50cfcda7d16";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "ad259f01e953263f40a39b14a538d076710c19207af936feabdf03bda7f067a5";
      result = "valid";
      flags = [];
    },
    {
      tcId = 120;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004946c278288616aa34790ca193686e745d3d58702866ddf1e95550711a9bfbdb87bc337a1c82e3c5f7a2927987b8fae13627237d220fafb4013123bfbd95f0ba5";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "5ec6025ac7b25c0f095f3fdee3e2e508bd1437b9705c2543c0e5af1c1d363ffd";
      result = "valid";
      flags = [];
    },
    {
      tcId = 121;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200047f195035feb2c04a9b149bb2ed3c5c458e95e7f7c418c4a07ea6107e4e32455addf9a666bf0015b20e4912f70f655ef21b82087596aa1e2f1e2865350d159185";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "a2f93a84574a26b43880cde6ed440c7f7cc72c92504d5271999a8a78ffe3491d";
      result = "valid";
      flags = [];
    },
    {
      tcId = 122;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000440855844e04303843a24b01707544d1bbf97673266e03d77fbf80d8b64219bd8503af4a2e3b26279564fed8e772a043e75630e4e3859976ede88ffcf16f5ca71";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "8d0cdb4977ba7661d41036aeb7a5f2dd207716d5d76eeb26629043c559ec2900";
      result = "valid";
      flags = [];
    },
    {
      tcId = 123;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000422cdb3ee47f14b3b0c0c8c256fb22e79126b436a2c9ff635a65151a0f0ffb1bfcf333562f3e018892374353674de8490fc9d30426598eb600779154baf2aec17";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "defde4aa48f89b03f623ea1f946f1aa938c5aab879ca6319596926f085578edc";
      result = "valid";
      flags = [];
    },
    {
      tcId = 124;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200042b7becd7066e22f121e7cf123d48c5445037c5a756ef314a66a7001636ee75cf1e6fe2c1a715163efaf86ea8b1e55ea5742d6b042e6cbf8acc69c99f8271a902";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "afe0bfed69a600163865406127a8972b613232aa4c933a06b5a5b5bcff1596f8";
      result = "valid";
      flags = [];
    },
    {
      tcId = 125;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004bb8da4a76ee3d1c4b33477bc8663def167a126c422ad47f6c2f8b539c6808936c1d5ee9fc3ce49fd4509d33c4dcfcc1a20a660529fa9ebd6e6afc3d5c84c72bb";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "f49bca7a6a5256ddf712775917c30e4873153469bae12fd5c5571031db7b1205";
      result = "valid";
      flags = [];
    },
    {
      tcId = 126;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200040a0c37664823a5005d659f7c73c39ea172c862969c81e44f36c89e7c265ec8a8f20a0ca618ba0131a2e373f31f73b3f55e9188d46fddbc6387e32aefb9f3ba12";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "9c88b611b7f9aad33fabb09cff618bb1ca6fb904a289b1481da3d1e4e72589e4";
      result = "valid";
      flags = [];
    },
    {
      tcId = 127;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000447c33f6f78d3cd9971ecc50e7e2ac947f8c1103f9c5f0821379bd06ad8fca45670c60975748f0c749a8b0f8fc1e222ddcbd3384f6d68f0b6b6ff679b435cdcb1";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "42f634c06c4a0e7e956db6e86666603d26374cc74b11026f0318d1a25681a712";
      result = "valid";
      flags = [];
    },
    {
      tcId = 128;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004b59d18ab8b0f9dd33484f43c3f6860229ba6a4c25a61cd0aaca23b76d60566cf5aa9c0d1b240e6dd4211e3235425634b278ad88fede0337d5acf3136587d8413";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "e2ceb946e7993f27a4327abdf61d4f06577e89c63b62a24aefbd905710d18669";
      result = "valid";
      flags = [];
    },
    {
      tcId = 129;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000494f4601b244d3a6ea6996fa244364f794399e0ff4316157db6023222fc0d90be4ba2e420cabc43b6e8e86590fc2383d17827dd99a60c211f190a74269100c141";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "71637a5da2412a921f1636c69a6ee81083ee2b0e13766ad122791ef6f771896d";
      result = "valid";
      flags = [];
    },
    {
      tcId = 130;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200049e8c115b1ac87d986ee1b506b86a4e7b8ea041aa6a63d6ec80ec0f0cf69cfb3f2702a515a9a50db1d86fd42aea0834daeb62be03d0cd9033f84b9c4b56a19f12";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "bd265ed3078ca8c7788f594187c96c675aa623ecd01bfcad62d76a7881334f63";
      result = "valid";
      flags = [];
    },
    {
      tcId = 131;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004eec776b52b94141fc819d4b6b12d28e73555b5560507aba7df6f0484008de91f104277170692fa6bf2270580d56d1bc81b54f477d8ab6c3f5842650ac7176d71";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "8d073fc592fb7aa6f7b908ed07148aa7be5a135c4b343ebe295198cba78e71ce";
      result = "valid";
      flags = [];
    },
    {
      tcId = 132;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004aff46a388e5afc220a8eec7a49af9d245384a3af1e0b407b4521f4e92d12dceb5d367688fde5e082f097855a0c0adc305dd6cf46f50ca75859bb243b70249605";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "a26d698e4613595aa61c8e2907d5241d6d14909737df59895841d07727bf1348";
      result = "valid";
      flags = [];
    },
    {
      tcId = 133;
      comment = "point with coordinate y = 1 in left to right addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004e807e43d96f3701a9a5c13d122749084170fcd36a586a446c9fcb4600eede4fdf4d1d22af7187c8de1b992a4046c419b801cde57d638d30f2e1ac49353117a20";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "a8edc6f9af6bf74122c11ca1a50afbc4a3c4987bd0d1f73284d2c1371e613405";
      result = "valid";
      flags = [];
    },
    {
      tcId = 134;
      comment = "point with coordinate y = 1 in precomputation or right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004798868a56916d341e7d6f96359ae3658836e221459f4f7b7b63694de18a5e9247713fdb03a8de8c6d29ca38a9fbaa82e5e02bead2f9eec69b6444b7adb05333b";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "17963de078996eb8503c7cc3e1a2d5147d7f0bfb251a020b4392033063587c8d";
      result = "valid";
      flags = [];
    },
    {
      tcId = 135;
      comment = "point with coordinate y = 1 in precomputation or right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004ff419909d8a8ce0a9416051f4e256208c1dc035581a53312d566137e22104e9877421ab01e00e83841b946dae5bb5a23973daa98fe1a8172883abcbedced7021";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "062799a19545d31b3ed72253bcde59762aa6104a88ac5e2fb68926b0f7146698";
      result = "valid";
      flags = [];
    },
    {
      tcId = 136;
      comment = "point with coordinate y = 1 in precomputation or right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200048b48119d7089d3b95cd2eaf8c85584fa8f5e56c4c4ccee7037d74cdbf88e571714c1aac5f0bf1b48a4abcf1d9291b9a8776a004380546a5a1c1f294690f61969";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "9f42dd8fce13f8103b3b2bc15e61242e6820fe1325a20ef460fe64d9eb12b231";
      result = "valid";
      flags = [];
    },
    {
      tcId = 137;
      comment = "point with coordinate y = 1 in precomputation or right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004e2888119379b5b2151bd788505def1d6bd786329431caf39705d9cbf96a42ea43bb7328839d2aecac64b1cdb182f08adccaac327ed008987a10edc9732413ced";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "d1b204e52d1fac6d504132c76ca233c87e377dcc79c893c970ddbb9f87b27fa0";
      result = "valid";
      flags = [];
    },
    {
      tcId = 138;
      comment = "point with coordinate y = 1 in precomputation or right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200046dcc3971bd20913d59a91f20d912f56d07e7f014206bef4a653ddfe5d12842c39b51b17b76ea6cc137eebd93c811e636d8ae26c70d064650f7205a865d01a6ee";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "c8d6bd28c1e65ae7c7a5debe67a7dfaf92b429ede368efc9da7d578a539b7054";
      result = "valid";
      flags = [];
    },
    {
      tcId = 139;
      comment = "point with coordinate y = 1 in precomputation or right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200047ebea45854569a1f7ea6b95b82d6befefbf6296ebc87c810b6cba93c0c1220b23f1874fa08a693b086643ef21eb59d75562da9422d13d9a39b0b17e241b04d32";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "0d1f905cc74720bde67ae84f582728588c75444c273dae4106fa20d1d6946430";
      result = "valid";
      flags = [];
    },
    {
      tcId = 140;
      comment = "point with coordinate y = 1 in precomputation or right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004ceab5937900d34fa88378d371f4acaa7c6a2028b6143213413f16ba2dc7147877713fdb03a8de8c6d29ca38a9fbaa82e5e02bead2f9eec69b6444b7adb05333b";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "3f014e309192588fa83e47d4ac9685d2041204e2eaf633a1312812e51ae74cbd";
      result = "valid";
      flags = [];
    },
    {
      tcId = 141;
      comment = "point with coordinate y = 1 in precomputation or right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004a4ffea5e25f75e4f689c81084a35c1220e8e6b914c482f4a2e8f93cffca6964777421ab01e00e83841b946dae5bb5a23973daa98fe1a8172883abcbedced7021";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "68b404d556c82004c6c4bba4518ec00b1d4f1161cafe6c89aeb8494a9ba09db5";
      result = "valid";
      flags = [];
    },
    {
      tcId = 142;
      comment = "point with coordinate y = 1 in precomputation or right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004de8809ea0ecce1d24a0431429510383a6f6e5a1c51cea32d830c6c353042603e14c1aac5f0bf1b48a4abcf1d9291b9a8776a004380546a5a1c1f294690f61969";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "c331ade7a457df7f12a2f5c43d7ea9486c1563b81cd8a0f23f923c1a9fa612e3";
      result = "valid";
      flags = [];
    },
    {
      tcId = 143;
      comment = "point with coordinate y = 1 in precomputation or right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004566209f174d6bf79720b70edb27e51350beeb2b0bcd083bbae7214f71cf824d43bb7328839d2aecac64b1cdb182f08adccaac327ed008987a10edc9732413ced";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "17b5c7a311eea9d2ab7571f8b9f848d4705997cf3eaf9bdcbe0e34a670f81f45";
      result = "valid";
      flags = [];
    },
    {
      tcId = 144;
      comment = "point with coordinate y = 1 in precomputation or right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004cc3181c0127137536ceec94fd45996657df72e0f97c44b9dad14763ce506e9dc9b51b17b76ea6cc137eebd93c811e636d8ae26c70d064650f7205a865d01a6ee";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "2f0e4eccbc4518ace558e06604f9bff4787f5b019437b52195ecb6b82191a6ae";
      result = "valid";
      flags = [];
    },
    {
      tcId = 145;
      comment = "point with coordinate y = 1 in precomputation or right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004d7052a1eeafc0e78d79e7f26003aa0a409287cf476007df28d281b142be1a0e23f1874fa08a693b086643ef21eb59d75562da9422d13d9a39b0b17e241b04d32";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "7494d864cb6ea9c5d982d40a5f103700d02dc982637753cfc7d8afe1beafff70";
      result = "valid";
      flags = [];
    },
    {
      tcId = 146;
      comment = "point with coordinate y = 1 in precomputation or right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004b7cc3e2306dbf7c38ff179658706feffb5efdb6044c7e71435d7ff7d0ae8c7b37713fdb03a8de8c6d29ca38a9fbaa82e5e02bead2f9eec69b6444b7adb05333b";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "a96873eef5d438b807853b6771c6a5197e6eef21efefca538b45e9e981c032e5";
      result = "valid";
      flags = [];
    },
    {
      tcId = 147;
      comment = "point with coordinate y = 1 in precomputation or right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200045bbe7c98015fd3a6034d79d867a4dcd52f95911932129da2fc0a58afe149137f77421ab01e00e83841b946dae5bb5a23973daa98fe1a8172883abcbedced7021";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "9124618913f20cdffa642207f192e67eb80ade53ac5535469abe90036d4af7e2";
      result = "valid";
      flags = [];
    },
    {
      tcId = 148;
      comment = "point with coordinate y = 1 in precomputation or right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004962fe47880a94a745928e3c4a29a42cb01334f1ee9646e62451c46ecd72f410914c1aac5f0bf1b48a4abcf1d9291b9a8776a004380546a5a1c1f294690f61969";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "9d8b74888d942870b221de7a642032892bc99e34bd8550195f6f5f097547334a";
      result = "valid";
      flags = [];
    },
    {
      tcId = 149;
      comment = "point with coordinate y = 1 in precomputation or right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004c71574f5538de5653c37168d47a2bcf43698ea260012cd0ae1304e474c63a4e63bb7328839d2aecac64b1cdb182f08adccaac327ed008987a10edc9732413ced";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "16983377c0f1a9c004495b3fd9658363116eea644787d059d1140fb907555d4a";
      result = "valid";
      flags = [];
    },
    {
      tcId = 150;
      comment = "point with coordinate y = 1 in precomputation or right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004c60244ce306e376f3968178f5293742d7a20e1dc47cfc517edada9db49d0cbbf9b51b17b76ea6cc137eebd93c811e636d8ae26c70d064650f7205a865d01a6ee";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "081af40a81d48c6b530140db935e605bf4cc7b10885f5b148f95f1bc8ad2e52d";
      result = "valid";
      flags = [];
    },
    {
      tcId = 151;
      comment = "point with coordinate y = 1 in precomputation or right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004aa3c3188c0ad5767a9bac77e7ceea05cfae1599ccd77b9fcbc0c3badc80c36ca3f1874fa08a693b086643ef21eb59d75562da9422d13d9a39b0b17e241b04d32";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "7e4b973e6d4a357c400243a648c8a0a6a35cf231754afdef312d2f4b6abb988f";
      result = "valid";
      flags = [];
    },
    {
      tcId = 152;
      comment = "point with coordinate y = 1 in right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200042cce8ddfe4827dc030ddf38f998b3f2ed5e0621d0b3805666daf48c8c31e75e5198d9ef4e973b6bdebe119a35faae86191acd758c1ed8accaf1e706ad55d83d7";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "0f0235da2a06c8d408c27151f3f15342ed8c1945aaf84ed14993786d6ac5f570";
      result = "valid";
      flags = [];
    },
    {
      tcId = 153;
      comment = "point with coordinate y = 1 in right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000414bfc3e5a46b69881a9a346d95894418614ed91476a1ddce48676b7cbab9ba02f334d64f2caf561b063bc1f7889e937302a455ff685d8ae57cb2444a17dad068";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "5622c2fbe8af5ad6cef72a01be186e554847576106f8979772fa56114d1160ab";
      result = "valid";
      flags = [];
    },
    {
      tcId = 154;
      comment = "point with coordinate y = 1 in right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004bd442fa5a2a8d72e13e44fd2222c85a006f03375e0211b272f555052b03db750be345737f7c6b5e70e97d9fe9dc4ca94fb185f4b9d2a00e086c1d47273b33602";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "bb95e0d0fbaad86c5bd87b95946c77ff1d65322a175ccf16419102c0a17f5a72";
      result = "valid";
      flags = [];
    },
    {
      tcId = 155;
      comment = "point with coordinate y = 1 in right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200040d7a3ff49bda6a587ed07691450425aa02d253ba573a16ad86c61af412dd3c770b6d3b9e570ba004877c9a69e481fe215de03a70126305a452826e66d9b5583e";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "4510683c7bfa251f0cb56bba7e0ab74d90f5e2ca01e91e7ca99312ccff2d90b6";
      result = "valid";
      flags = [];
    },
    {
      tcId = 156;
      comment = "point with coordinate y = 1 in right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004bdea5d2a3adde7df2e839ff63f62534b3f27cb191bb54dfa1d39cbff713ba9ed307d8f1d02c6f07146655e6383b0ef3035bee7067c336fdb91365e197a97b616";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "025485142ca1ced752289f772130fc10c75a4508c46bffdef9290ad3e7baf9ca";
      result = "valid";
      flags = [];
    },
    {
      tcId = 157;
      comment = "point with coordinate y = 1 in right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004d4c063e3c036f47c92f6f5470a26a835e1a24505b14d1b29279062a16cf6f489198d9ef4e973b6bdebe119a35faae86191acd758c1ed8accaf1e706ad55d83d7";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "9067932150724965aa479c1ef1be55544bed9fa94500a3b67887ed91ae3b81e5";
      result = "valid";
      flags = [];
    },
    {
      tcId = 158;
      comment = "point with coordinate y = 1 in right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200043cb9f07997756859e9b9a85b681fa50ee20357f535c1b311c4637d16b76b9ebff334d64f2caf561b063bc1f7889e937302a455ff685d8ae57cb2444a17dad068";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "f8084a89adccdc3aef89e5091a0f07d6160a66cb9575241100c1d39bf0549ae2";
      result = "valid";
      flags = [];
    },
    {
      tcId = 159;
      comment = "point with coordinate y = 1 in right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004793412ff636c08a2d0f6d60cc608e9a9098349a2501f91c95f692010bc1238b2be345737f7c6b5e70e97d9fe9dc4ca94fb185f4b9d2a00e086c1d47273b33602";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "4462558c89902117051cb2c599ad66f00887b54cae3da9c04d317a5b2afb463b";
      result = "valid";
      flags = [];
    },
    {
      tcId = 160;
      comment = "point with coordinate y = 1 in right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004bd1eb0849e2e6a13d54b76518f11ba8775c2d7634d85152534bc7c3af4161efa0b6d3b9e570ba004877c9a69e481fe215de03a70126305a452826e66d9b5583e";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "30b4741a64f87d28ec0029bd196b5a74555f2c9a976a46d628572474466a631d";
      result = "valid";
      flags = [];
    },
    {
      tcId = 161;
      comment = "point with coordinate y = 1 in right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004624b3b4ba993a8b938125689f6cf757392ee390d14a90fea6db944b5a8deb8d0307d8f1d02c6f07146655e6383b0ef3035bee7067c336fdb91365e197a97b616";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "3afc04ac92117e50b0913b09dbbb4e6c780c051500201fad512b79080bff39e2";
      result = "valid";
      flags = [];
    },
    {
      tcId = 162;
      comment = "point with coordinate y = 1 in right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004fe710e3c5b468dc33c2b17295c4e189b487d58dd437adf706ac05493cfea8df0198d9ef4e973b6bdebe119a35faae86191acd758c1ed8accaf1e706ad55d83d7";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "609637048586edc64cf5f28f1a505768c686471110070d783de499ffe6fe84da";
      result = "valid";
      flags = [];
    },
    {
      tcId = 163;
      comment = "point with coordinate y = 1 in right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004ae864ba0c41f2e1dfbac2337025716d8bcadcef6539c6f1ff335176b8ddaa36ef334d64f2caf561b063bc1f7889e937302a455ff685d8ae57cb2444a17dad068";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "b1d4f27a6983c8ee417ef0f527d889d4a1ae41d3639244578c43d650c299fcd1";
      result = "valid";
      flags = [];
    },
    {
      tcId = 164;
      comment = "point with coordinate y = 1 in right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004c987bd5af9eb202f1b24da2117ca90b6ef8c82e7cfbf530f71418f9a93b0085cbe345737f7c6b5e70e97d9fe9dc4ca94fb185f4b9d2a00e086c1d47273b33602";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "0007c9a27ac5067c9f0ad1a4d1e62110da1318893a658729713d82e333855b82";
      result = "valid";
      flags = [];
    },
    {
      tcId = 165;
      comment = "point with coordinate y = 1 in right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000435670f86c5f72b93abe4131d2bea1fce876ad4e25b40d42d447d68cff90ca0be0b6d3b9e570ba004877c9a69e481fe215de03a70126305a452826e66d9b5583e";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "8a3b23a91f0d5db8074a6a886889ee3e19aaf09b66ac9aad2e15c8bdba68085c";
      result = "valid";
      flags = [];
    },
    {
      tcId = 166;
      comment = "point with coordinate y = 1 in right to left addition chain";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004dfca678a1b8e6f67996a097fc9ce37412de9fbd9cfa1a21b750cef48e5e595a1307d8f1d02c6f07146655e6383b0ef3035bee7067c336fdb91365e197a97b616";
      privateKey = "00c1781d86cac2c052b865f228e64bd1ce433c78ca7dfca9e8b810473e2ce17da5";
      output = "c2af763f414cb2d7fd46257f0313b582c099b5e23b73e073b5ab7c230c45c883";
      result = "valid";
      flags = [];
    },
    {
      tcId = 167;
      comment = "edge case private key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000432bdd978eb62b1f369a56d0949ab8551a7ad527d9602e891ce457586c2a8569e981e67fae053b03fc33e1a291f0a3beb58fceb2e85bb1205dacee1232dfd316b";
      privateKey = "03";
      output = "34005694e3cac09332aa42807e3afdc3b3b3bc7c7be887d1f98d76778c55cfd7";
      result = "valid";
      flags = [];
    },
    {
      tcId = 168;
      comment = "edge case private key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000432bdd978eb62b1f369a56d0949ab8551a7ad527d9602e891ce457586c2a8569e981e67fae053b03fc33e1a291f0a3beb58fceb2e85bb1205dacee1232dfd316b";
      privateKey = "00ffffffffffffffffffffffffffffffffffffffffffffffffffffffff";
      output = "5841acd3cff2d62861bbe11084738006d68ccf35acae615ee9524726e93d0da5";
      result = "valid";
      flags = [];
    },
    {
      tcId = 169;
      comment = "edge case private key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000432bdd978eb62b1f369a56d0949ab8551a7ad527d9602e891ce457586c2a8569e981e67fae053b03fc33e1a291f0a3beb58fceb2e85bb1205dacee1232dfd316b";
      privateKey = "0100000000000000000000000000000000000000000000000000000000000000";
      output = "4348e4cba371ead03982018abc9aacecaebfd636dda82e609fd298947f907de8";
      result = "valid";
      flags = [];
    },
    {
      tcId = 170;
      comment = "edge case private key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000432bdd978eb62b1f369a56d0949ab8551a7ad527d9602e891ce457586c2a8569e981e67fae053b03fc33e1a291f0a3beb58fceb2e85bb1205dacee1232dfd316b";
      privateKey = "7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff";
      output = "e56221c2b0dc33b98b90dfd3239a2c0cb1e4ad0399a3aaef3f9d47fb103daef0";
      result = "valid";
      flags = [];
    },
    {
      tcId = 171;
      comment = "edge case private key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000432bdd978eb62b1f369a56d0949ab8551a7ad527d9602e891ce457586c2a8569e981e67fae053b03fc33e1a291f0a3beb58fceb2e85bb1205dacee1232dfd316b";
      privateKey = "008000000000000000000000000000000000000000000000000000000000000000";
      output = "5b34a29b1c4ddcb2101162d34bed9f0702361fe5af505df315eff7befd0e4719";
      result = "valid";
      flags = [];
    },
    {
      tcId = 172;
      comment = "edge case private key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000432bdd978eb62b1f369a56d0949ab8551a7ad527d9602e891ce457586c2a8569e981e67fae053b03fc33e1a291f0a3beb58fceb2e85bb1205dacee1232dfd316b";
      privateKey = "00fffffffffffffffffffffffffffffffebaaedce6af48a03abfd25e8cd0364141";
      output = "cece521b8b5a32bbee38936ba7d645824f238e561701a386fb888e010db54b2f";
      result = "valid";
      flags = [];
    },
    {
      tcId = 173;
      comment = "edge case private key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000432bdd978eb62b1f369a56d0949ab8551a7ad527d9602e891ce457586c2a8569e981e67fae053b03fc33e1a291f0a3beb58fceb2e85bb1205dacee1232dfd316b";
      privateKey = "00fffffffffffffffffffffffffffffffebaaedce6af48a03bbfc25e8cd0364141";
      output = "829521b79d71f5011e079756b851a0d5c83557866189a6258c1e78a1700c6904";
      result = "valid";
      flags = [];
    },
    {
      tcId = 174;
      comment = "edge case private key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000432bdd978eb62b1f369a56d0949ab8551a7ad527d9602e891ce457586c2a8569e981e67fae053b03fc33e1a291f0a3beb58fceb2e85bb1205dacee1232dfd316b";
      privateKey = "00fffffffffffffffffffffffffffffffebaaedce6af48a03bbfca5e8cd0364141";
      output = "8c5934793505a6a1f84d41283341680c4923f1f4d562989a11cc626fea5eda5a";
      result = "valid";
      flags = [];
    },
    {
      tcId = 175;
      comment = "edge case private key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000432bdd978eb62b1f369a56d0949ab8551a7ad527d9602e891ce457586c2a8569e981e67fae053b03fc33e1a291f0a3beb58fceb2e85bb1205dacee1232dfd316b";
      privateKey = "00fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8bd0364141";
      output = "356caee7e7eee031a15e54c3a5c4e72f9c74bb287ce601619ef85eb96c289452";
      result = "valid";
      flags = [];
    },
    {
      tcId = 176;
      comment = "edge case private key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000432bdd978eb62b1f369a56d0949ab8551a7ad527d9602e891ce457586c2a8569e981e67fae053b03fc33e1a291f0a3beb58fceb2e85bb1205dacee1232dfd316b";
      privateKey = "00fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd03640c3";
      output = "09c7337df6c2b35edf3a21382511cc5add1a71a84cbf8d3396a5be548d92fa67";
      result = "valid";
      flags = ["AddSubChain"];
    },
    {
      tcId = 177;
      comment = "edge case private key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000432bdd978eb62b1f369a56d0949ab8551a7ad527d9602e891ce457586c2a8569e981e67fae053b03fc33e1a291f0a3beb58fceb2e85bb1205dacee1232dfd316b";
      privateKey = "00fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364103";
      output = "d16caedd25793666f9e26f5331382106f54095b3d20d40c745b68ca76c0e6983";
      result = "valid";
      flags = ["AddSubChain"];
    },
    {
      tcId = 178;
      comment = "edge case private key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000432bdd978eb62b1f369a56d0949ab8551a7ad527d9602e891ce457586c2a8569e981e67fae053b03fc33e1a291f0a3beb58fceb2e85bb1205dacee1232dfd316b";
      privateKey = "00fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364123";
      output = "b8ae1e21d8b34ce4caffed7167a26868ec80a7d4a6a98b639d4d05cd226504de";
      result = "valid";
      flags = ["AddSubChain"];
    },
    {
      tcId = 179;
      comment = "edge case private key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000432bdd978eb62b1f369a56d0949ab8551a7ad527d9602e891ce457586c2a8569e981e67fae053b03fc33e1a291f0a3beb58fceb2e85bb1205dacee1232dfd316b";
      privateKey = "00fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364133";
      output = "02776315fe147a36a4b0987492b6503acdea60f926450e5eddb9f88fc82178d3";
      result = "valid";
      flags = ["AddSubChain"];
    },
    {
      tcId = 180;
      comment = "edge case private key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000432bdd978eb62b1f369a56d0949ab8551a7ad527d9602e891ce457586c2a8569e981e67fae053b03fc33e1a291f0a3beb58fceb2e85bb1205dacee1232dfd316b";
      privateKey = "00fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd036413b";
      output = "3988c9c7050a28794934e5bd67629b556d97a4858d22812835f4a37dca351943";
      result = "valid";
      flags = ["AddSubChain"];
    },
    {
      tcId = 181;
      comment = "edge case private key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000432bdd978eb62b1f369a56d0949ab8551a7ad527d9602e891ce457586c2a8569e981e67fae053b03fc33e1a291f0a3beb58fceb2e85bb1205dacee1232dfd316b";
      privateKey = "00fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd036413e";
      output = "34005694e3cac09332aa42807e3afdc3b3b3bc7c7be887d1f98d76778c55cfd7";
      result = "valid";
      flags = [];
    },
    {
      tcId = 182;
      comment = "edge case private key";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000432bdd978eb62b1f369a56d0949ab8551a7ad527d9602e891ce457586c2a8569e981e67fae053b03fc33e1a291f0a3beb58fceb2e85bb1205dacee1232dfd316b";
      privateKey = "00fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd036413f";
      output = "4b52257d8b3ba387797fdf7a752f195ddc4f7d76263de61d0d52a5ec14a36cbf";
      result = "valid";
      flags = ["AddSubChain"];
    },
    {
      tcId = 183;
      comment = "point is not on curve";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
      privateKey = "00c6cafb74e2a50c83b3d232c4585237f44d4c5433c4b3f50ce978e6aeda3a4f5d";
      output = "";
      result = "invalid";
      flags = [];
    },
    {
      tcId = 184;
      comment = "point is not on curve";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001";
      privateKey = "00c6cafb74e2a50c83b3d232c4585237f44d4c5433c4b3f50ce978e6aeda3a4f5d";
      output = "";
      result = "invalid";
      flags = [];
    },
    {
      tcId = 185;
      comment = "point is not on curve";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200040000000000000000000000000000000000000000000000000000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2e";
      privateKey = "00c6cafb74e2a50c83b3d232c4585237f44d4c5433c4b3f50ce978e6aeda3a4f5d";
      output = "";
      result = "invalid";
      flags = [];
    },
    {
      tcId = 186;
      comment = "point is not on curve";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200040000000000000000000000000000000000000000000000000000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f";
      privateKey = "00c6cafb74e2a50c83b3d232c4585237f44d4c5433c4b3f50ce978e6aeda3a4f5d";
      output = "";
      result = "invalid";
      flags = [];
    },
    {
      tcId = 187;
      comment = "point is not on curve";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000400000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000";
      privateKey = "00c6cafb74e2a50c83b3d232c4585237f44d4c5433c4b3f50ce978e6aeda3a4f5d";
      output = "";
      result = "invalid";
      flags = [];
    },
    {
      tcId = 188;
      comment = "point is not on curve";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000400000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001";
      privateKey = "00c6cafb74e2a50c83b3d232c4585237f44d4c5433c4b3f50ce978e6aeda3a4f5d";
      output = "";
      result = "invalid";
      flags = [];
    },
    {
      tcId = 189;
      comment = "point is not on curve";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200040000000000000000000000000000000000000000000000000000000000000001fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2e";
      privateKey = "00c6cafb74e2a50c83b3d232c4585237f44d4c5433c4b3f50ce978e6aeda3a4f5d";
      output = "";
      result = "invalid";
      flags = [];
    },
    {
      tcId = 190;
      comment = "point is not on curve";
      publicKey = "3056301006072a8648ce3d020106052b8104000a034200040000000000000000000000000000000000000000000000000000000000000001fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f";
      privateKey = "00c6cafb74e2a50c83b3d232c4585237f44d4c5433c4b3f50ce978e6aeda3a4f5d";
      output = "";
      result = "invalid";
      flags = [];
    },
    {
      tcId = 191;
      comment = "point is not on curve";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2e0000000000000000000000000000000000000000000000000000000000000000";
      privateKey = "00c6cafb74e2a50c83b3d232c4585237f44d4c5433c4b3f50ce978e6aeda3a4f5d";
      output = "";
      result = "invalid";
      flags = [];
    },
    {
      tcId = 192;
      comment = "point is not on curve";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2e0000000000000000000000000000000000000000000000000000000000000001";
      privateKey = "00c6cafb74e2a50c83b3d232c4585237f44d4c5433c4b3f50ce978e6aeda3a4f5d";
      output = "";
      result = "invalid";
      flags = [];
    },
    {
      tcId = 193;
      comment = "point is not on curve";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2efffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2e";
      privateKey = "00c6cafb74e2a50c83b3d232c4585237f44d4c5433c4b3f50ce978e6aeda3a4f5d";
      output = "";
      result = "invalid";
      flags = [];
    },
    {
      tcId = 194;
      comment = "point is not on curve";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2efffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f";
      privateKey = "00c6cafb74e2a50c83b3d232c4585237f44d4c5433c4b3f50ce978e6aeda3a4f5d";
      output = "";
      result = "invalid";
      flags = [];
    },
    {
      tcId = 195;
      comment = "point is not on curve";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f0000000000000000000000000000000000000000000000000000000000000000";
      privateKey = "00c6cafb74e2a50c83b3d232c4585237f44d4c5433c4b3f50ce978e6aeda3a4f5d";
      output = "";
      result = "invalid";
      flags = [];
    },
    {
      tcId = 196;
      comment = "point is not on curve";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f0000000000000000000000000000000000000000000000000000000000000001";
      privateKey = "00c6cafb74e2a50c83b3d232c4585237f44d4c5433c4b3f50ce978e6aeda3a4f5d";
      output = "";
      result = "invalid";
      flags = [];
    },
    {
      tcId = 197;
      comment = "point is not on curve";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2ffffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2e";
      privateKey = "00c6cafb74e2a50c83b3d232c4585237f44d4c5433c4b3f50ce978e6aeda3a4f5d";
      output = "";
      result = "invalid";
      flags = [];
    },
    {
      tcId = 198;
      comment = "point is not on curve";
      publicKey = "3056301006072a8648ce3d020106052b8104000a03420004fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2ffffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f";
      privateKey = "00c6cafb74e2a50c83b3d232c4585237f44d4c5433c4b3f50ce978e6aeda3a4f5d";
      output = "";
      result = "invalid";
      flags = [];
    },
    {
      tcId = 199;
      comment = "";
      publicKey = "3015301006072a8648ce3d020106052b8104000a030100";
      privateKey = "00c6cafb74e2a50c83b3d232c4585237f44d4c5433c4b3f50ce978e6aeda3a4f5d";
      output = "";
      result = "invalid";
      flags = [];
    },
    {
      tcId = 200;
      comment = "public point not on curve";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000449c248edc659e18482b7105748a4b95d3a46952a5ba72da0d702dc97a64e99799d8cff7a5c4b925e4360ece25ccf307d7a9a7063286bbd16ef64c65f546757e4";
      privateKey = "00cfe75ee764197aa7732a5478556b478898423d2bc0e484a6ebb3674a6036a65d";
      output = "";
      result = "invalid";
      flags = ["InvalidPublic"];
    },
    {
      tcId = 201;
      comment = "public point = (0,0)";
      publicKey = "3056301006072a8648ce3d020106052b8104000a0342000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
      privateKey = "00cfe75ee764197aa7732a5478556b478898423d2bc0e484a6ebb3674a6036a65d";
      output = "";
      result = "invalid";
      flags = ["InvalidPublic"];
    },
    {
      tcId = 204;
      comment = "order = 1";
      publicKey = "3081d530818e06072a8648ce3d0201308182020101302c06072a8648ce3d0101022100fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f300604010004010704410479be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b80201010201010342000449c248edc659e18482b7105748a4b95d3a46952a5ba72da0d702dc97a64e99799d8cff7a5c4b925e4360ece25ccf307d7a9a7063286bbd16ef64c65f546757e2";
      privateKey = "00cfe75ee764197aa7732a5478556b478898423d2bc0e484a6ebb3674a6036a65d";
      output = "380c53e0a509ebb3b63346598105219b43d51ae196b4557d59bbd67824032dff";
      result = "acceptable";
      flags = ["WrongOrder", "UnusedParam", "UnnamedCurve"];
    },
    {
      tcId = 205;
      comment = "order = 26959946667150639794667015087019630673536463705607434823784316690060";
      publicKey = "3081f13081aa06072a8648ce3d020130819e020101302c06072a8648ce3d0101022100fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f300604010004010704410479be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8021d00fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8c0201010342000449c248edc659e18482b7105748a4b95d3a46952a5ba72da0d702dc97a64e99799d8cff7a5c4b925e4360ece25ccf307d7a9a7063286bbd16ef64c65f546757e2";
      privateKey = "00cfe75ee764197aa7732a5478556b478898423d2bc0e484a6ebb3674a6036a65d";
      output = "380c53e0a509ebb3b63346598105219b43d51ae196b4557d59bbd67824032dff";
      result = "acceptable";
      flags = ["WrongOrder", "UnusedParam", "UnnamedCurve"];
    },
    {
      tcId = 206;
      comment = "generator = (0,0)";
      publicKey = "3081f53081ae06072a8648ce3d02013081a2020101302c06072a8648ce3d0101022100fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f300604010004010704410400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000022100fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd03641410201010342000449c248edc659e18482b7105748a4b95d3a46952a5ba72da0d702dc97a64e99799d8cff7a5c4b925e4360ece25ccf307d7a9a7063286bbd16ef64c65f546757e2";
      privateKey = "00cfe75ee764197aa7732a5478556b478898423d2bc0e484a6ebb3674a6036a65d";
      output = "380c53e0a509ebb3b63346598105219b43d51ae196b4557d59bbd67824032dff";
      result = "acceptable";
      flags = ["UnusedParam", "UnnamedCurve"];
    },
    {
      tcId = 207;
      comment = "generator not on curve";
      publicKey = "3081f53081ae06072a8648ce3d02013081a2020101302c06072a8648ce3d0101022100fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f300604010004010704410479be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4ba022100fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd03641410201010342000449c248edc659e18482b7105748a4b95d3a46952a5ba72da0d702dc97a64e99799d8cff7a5c4b925e4360ece25ccf307d7a9a7063286bbd16ef64c65f546757e2";
      privateKey = "00cfe75ee764197aa7732a5478556b478898423d2bc0e484a6ebb3674a6036a65d";
      output = "380c53e0a509ebb3b63346598105219b43d51ae196b4557d59bbd67824032dff";
      result = "acceptable";
      flags = ["UnusedParam", "UnnamedCurve"];
    },
    {
      tcId = 210;
      comment = "cofactor = 2";
      publicKey = "3081f53081ae06072a8648ce3d02013081a2020101302c06072a8648ce3d0101022100fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f300604010004010704410479be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8022100fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd03641410201020342000449c248edc659e18482b7105748a4b95d3a46952a5ba72da0d702dc97a64e99799d8cff7a5c4b925e4360ece25ccf307d7a9a7063286bbd16ef64c65f546757e2";
      privateKey = "00cfe75ee764197aa7732a5478556b478898423d2bc0e484a6ebb3674a6036a65d";
      output = "380c53e0a509ebb3b63346598105219b43d51ae196b4557d59bbd67824032dff";
      result = "acceptable";
      flags = ["UnusedParam", "UnnamedCurve"];
    },
    {
      tcId = 212;
      comment = "cofactor = None";
      publicKey = "3081f23081ab06072a8648ce3d020130819f020101302c06072a8648ce3d0101022100fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f300604010004010704410479be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8022100fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd03641410342000449c248edc659e18482b7105748a4b95d3a46952a5ba72da0d702dc97a64e99799d8cff7a5c4b925e4360ece25ccf307d7a9a7063286bbd16ef64c65f546757e2";
      privateKey = "00cfe75ee764197aa7732a5478556b478898423d2bc0e484a6ebb3674a6036a65d";
      output = "380c53e0a509ebb3b63346598105219b43d51ae196b4557d59bbd67824032dff";
      result = "acceptable";
      flags = ["UnusedParam", "UnnamedCurve"];
    },
    {
      tcId = 214;
      comment = "using secp224r1";
      publicKey = "304e301006072a8648ce3d020106052b81040021033a0004074f56dc2ea648ef89c3b72e23bbd2da36f60243e4d2067b70604af1c2165cec2f86603d60c8a611d5b84ba3d91dfe1a480825bcc4af3bcf";
      privateKey = "00cfe75ee764197aa7732a5478556b478898423d2bc0e484a6ebb3674a6036a65d";
      output = "";
      result = "invalid";
      flags = ["InvalidPublic"];
    },
    {
      tcId = 215;
      comment = "using secp256r1";
      publicKey = "3059301306072a8648ce3d020106082a8648ce3d03010703420004cbf6606595a3ee50f9fceaa2798c2740c82540516b4e5a7d361ff24e9dd15364e5408b2e679f9d5310d1f6893b36ce16b4a507509175fcb52aea53b781556b39";
      privateKey = "00cfe75ee764197aa7732a5478556b478898423d2bc0e484a6ebb3674a6036a65d";
      output = "";
      result = "invalid";
      flags = ["InvalidPublic"];
    },
    {
      tcId = 216;
      comment = "a = 0";
      publicKey = "3081f53081ae06072a8648ce3d02013081a2020101302c06072a8648ce3d0101022100fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f300604010004010704410449c248edc659e18482b7105748a4b95d3a46952a5ba72da0d702dc97a64e99799d8cff7a5c4b925e4360ece25ccf307d7a9a7063286bbd16ef64c65f546757e2022100fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd03641410201010342000449c248edc659e18482b7105748a4b95d3a46952a5ba72da0d702dc97a64e99799d8cff7a5c4b925e4360ece25ccf307d7a9a7063286bbd16ef64c65f546757e2";
      privateKey = "00cfe75ee764197aa7732a5478556b478898423d2bc0e484a6ebb3674a6036a65d";
      output = "380c53e0a509ebb3b63346598105219b43d51ae196b4557d59bbd67824032dff";
      result = "acceptable";
      flags = ["UnusedParam", "UnnamedCurve"];
    },
    {
      tcId = 218;
      comment = "Public key uses wrong curve: secp224r1";
      publicKey = "304e301006072a8648ce3d020106052b81040021033a000450eb062b54940a455719d523e1ec106525dda34c2fd95ace62b9b16d315d323f089173d10c45dceff155942431750c00ca36f463828e9fab";
      privateKey = "00dafa209e0f81119a4afa3f1bc46e2f7947354e3727c608b05c4950b10386643a";
      output = "";
      result = "invalid";
      flags = [];
    },
    {
      tcId = 219;
      comment = "Public key uses wrong curve: secp256r1";
      publicKey = "3059301306072a8648ce3d020106082a8648ce3d0301070342000406372852584037722a7f9bfaad5661acb623162d45f70a552c617f4080e873aa43609275dff6dcaaa122a745d0f154681f9c7726867b43e7523b7f5ab5ea963e";
      privateKey = "00dafa209e0f81119a4afa3f1bc46e2f7947354e3727c608b05c4950b10386643a";
      output = "";
      result = "invalid";
      flags = [];
    },
    {
      tcId = 220;
      comment = "Public key uses wrong curve: secp384r1";
      publicKey = "3076301006072a8648ce3d020106052b81040022036200040ef5804731d918f037506ee00b8602b877c7d509ffa2c0847a86e7a2d358ba7c981c2a74b22401ac615307a6deb275402fa6c8218c3374f8a91752d2eff6bd14ad8cae596d2f37dae8aeec085760edf4fda9a7cf70253898a54183469072a561";
      privateKey = "00dafa209e0f81119a4afa3f1bc46e2f7947354e3727c608b05c4950b10386643a";
      output = "";
      result = "invalid";
      flags = [];
    },
    {
      tcId = 221;
      comment = "Public key uses wrong curve: secp521r1";
      publicKey = "30819b301006072a8648ce3d020106052b81040023038186000400921da57110db26c7838a69d574fc98588c5c07a792cb379f46664cc773c1e1f6fa16148667748ede232d1a1f1cea7f152c5d586172acbeaa48416bcbd70bb27f0f01b4477e1ae74bf4f093184a9f26f103712ccf6ceb45a0505b191606d897edaf872b37f0f90a933000a80fc3207048323c16883a3d67a90aa78bcc9c5e58d784b9b9";
      privateKey = "00dafa209e0f81119a4afa3f1bc46e2f7947354e3727c608b05c4950b10386643a";
      output = "";
      result = "invalid";
      flags = [];
    },
    {
      tcId = 222;
      comment = "Public key uses wrong curve: secp224k1";
      publicKey = "304e301006072a8648ce3d020106052b81040020033a000456dd09f8a8c19039286b6aa79d099ff3e35ff74400437d2072fd9faa7f2901db79d793f55268980f7d395055330a91b46bf4a62c3a528230";
      privateKey = "00dafa209e0f81119a4afa3f1bc46e2f7947354e3727c608b05c4950b10386643a";
      output = "";
      result = "invalid";
      flags = [];
    },
    {
      tcId = 223;
      comment = "Public key uses wrong curve: brainpoolP224r1";
      publicKey = "3052301406072a8648ce3d020106092b2403030208010105033a00042c9fdd1914cacdb28e39e6fc24b4c3c666cc0d438acc4529a6cc297a2d0fdecb3028d9e4d84c711db352379c080c78659969bdc5d3218901";
      privateKey = "00dafa209e0f81119a4afa3f1bc46e2f7947354e3727c608b05c4950b10386643a";
      output = "";
      result = "invalid";
      flags = [];
    },
    {
      tcId = 224;
      comment = "Public key uses wrong curve: brainpoolP256r1";
      publicKey = "305a301406072a8648ce3d020106092b240303020801010703420004120e4db849e5d960741c7d221aa80fe6e4fcd578191b7f845a68a6fcb8647719a6fffb6165d8ec39389eecc530839c321b2e9040027fba5d9cb9311df7cd3d4d";
      privateKey = "00dafa209e0f81119a4afa3f1bc46e2f7947354e3727c608b05c4950b10386643a";
      output = "";
      result = "invalid";
      flags = [];
    },
    {
      tcId = 225;
      comment = "Public key uses wrong curve: brainpoolP320r1";
      publicKey = "306a301406072a8648ce3d020106092b2403030208010109035200040efb1c104938f59a931fe6bf69f7ead4036d2336075a708e66b020e1bc5bb6d9cdc86d4e8fa181d7c7ea1af28353044e8cec12eec75a6dd87a5dc902024d93f8c8d9bf43b453fd919151f9bd7bb955c7";
      privateKey = "00dafa209e0f81119a4afa3f1bc46e2f7947354e3727c608b05c4950b10386643a";
      output = "";
      result = "invalid";
      flags = [];
    },
    {
      tcId = 226;
      comment = "Public key uses wrong curve: brainpoolP384r1";
      publicKey = "307a301406072a8648ce3d020106092b240303020801010b036200043e96d75b79214e69a4550e25375478bdc9c2a9d0178a77b5700bd5f12e3ce142f50c93dc1ee7268456d7eae2d44b718d6f159e896ae14fbe3aba397801a95e2bb6a9a761e865b289dd9db64aa07c794cedf77328543b94c9b54ce0cf04c60ac8";
      privateKey = "00dafa209e0f81119a4afa3f1bc46e2f7947354e3727c608b05c4950b10386643a";
      output = "";
      result = "invalid";
      flags = [];
    },
    {
      tcId = 227;
      comment = "Public key uses wrong curve: brainpoolP512r1";
      publicKey = "30819b301406072a8648ce3d020106092b240303020801010d03818200044f191130740f1b75ae13402960eb22ea801db80ed51a461e06a7b3ba60c9bddd132a6465bbee8afd70cfb4495efbda4f1567b958e6e305bfcb4ac8f05172688e0f2f175aa12425be3ab7271b42f258639e868677d1163c12e641229f1e6427761c9e294de51db564151b21a051d2f7a13661852799557a556a5f3c51d36d083a";
      privateKey = "00dafa209e0f81119a4afa3f1bc46e2f7947354e3727c608b05c4950b10386643a";
      output = "";
      result = "invalid";
      flags = [];
    },
    {
      tcId = 228;
      comment = "Public key uses wrong curve: brainpoolP224t1";
      publicKey = "3052301406072a8648ce3d020106092b2403030208010106033a00044964b948cefa39cd769e3480d4840a3c58e966161be80df02d9aab33b4a318a32f30130224edcefe0dd64342404e594aa334995b179f641f";
      privateKey = "00dafa209e0f81119a4afa3f1bc46e2f7947354e3727c608b05c4950b10386643a";
      output = "";
      result = "invalid";
      flags = [];
    },
    {
      tcId = 229;
      comment = "Public key uses wrong curve: brainpoolP256t1";
      publicKey = "305a301406072a8648ce3d020106092b24030302080101080342000411157979c08bcd175d34572209a85f3f5d602e35bdc3b553b0f19307672b31ba69d0556bce48c43e2e7e6177055221a4c4b7eb17ee9708f49216de76d6e92ab8";
      privateKey = "00dafa209e0f81119a4afa3f1bc46e2f7947354e3727c608b05c4950b10386643a";
      output = "";
      result = "invalid";
      flags = [];
    },
    {
      tcId = 230;
      comment = "Public key uses wrong curve: brainpoolP320t1";
      publicKey = "306a301406072a8648ce3d020106092b240303020801010a035200048bb517e198930eba57293419876a8793f711de37c27f200e6fb2c2b13e9fabd4fbc42ad61751ca583031ba76cbc6d745d115addc74eab63bf415c4fa20dbbecae98ac3c3da1a041705cf8959e2ccf453";
      privateKey = "00dafa209e0f81119a4afa3f1bc46e2f7947354e3727c608b05c4950b10386643a";
      output = "";
      result = "invalid";
      flags = [];
    },
    {
      tcId = 231;
      comment = "Public key uses wrong curve: brainpoolP384t1";
      publicKey = "307a301406072a8648ce3d020106092b240303020801010c036200045eb38d0261b744b03abef4ae7c17bc886b5b426bd910958f8a49ef62053048f869541b7a05d244315fc9cd74271ec3d518d94114b6006017f4ed5e3c06322baa1c75809a1057ba6fa46d1e1a9927a262e627940d5da538b5a3d1d794d9c866a4";
      privateKey = "00dafa209e0f81119a4afa3f1bc46e2f7947354e3727c608b05c4950b10386643a";
      output = "";
      result = "invalid";
      flags = [];
    },
    {
      tcId = 232;
      comment = "Public key uses wrong curve: brainpoolP512t1";
      publicKey = "30819b301406072a8648ce3d020106092b240303020801010e0381820004035fc238e57d980beae0215fb89108f9c6c4afda5d920f9d0583ee7d65f8778ecfff24a31d4f32deb6ea5f7e3adb6affb9327a5e62e09cba07c88b119fd104a83b7811e958e393971a5c9417412070b9f18b03be37e81e0bca5d3ff0873ed1f3113ed0fc57a0344321fb4d6c43f2f6e630a3d3883efe4c21df3e0f0b1208226b";
      privateKey = "00dafa209e0f81119a4afa3f1bc46e2f7947354e3727c608b05c4950b10386643a";
      output = "";
      result = "invalid";
      flags = [];
    },
    {
      tcId = 233;
      comment = "invalid public key";
      publicKey = "3036301006072a8648ce3d020106052b8104000a03220002977cb7fb9a0ec5b208e811d6a0795eb78d7642e3cac42a801bcc8fc0f06472d4";
      privateKey = "00d09182a4d0c94ba85f82eff9fc1bddb0b07d3f2af8632fc1c73a3604e8f0b335";
      output = "";
      result = "invalid";
      flags = ["CompressedPoint"];
    },
    {
      tcId = 234;
      comment = "public key is a low order point on twist";
      publicKey = "3036301006072a8648ce3d020106052b8104000a032200020000000000000000000000000000000000000000000000000000000000000000";
      privateKey = "0098b5c223cf9cc0920a5145ba1fd2f6afee7e1f66d0120b8536685fdf05ebb300";
      output = "";
      result = "invalid";
      flags = ["CompressedPoint"];
    },
    {
      tcId = 235;
      comment = "public key is a low order point on twist";
      publicKey = "3036301006072a8648ce3d020106052b8104000a032200030000000000000000000000000000000000000000000000000000000000000000";
      privateKey = "0098b5c223cf9cc0920a5145ba1fd2f6afee7e1f66d0120b8536685fdf05ebb2ff";
      output = "";
      result = "invalid";
      flags = ["CompressedPoint"];
    },
  ];
};

