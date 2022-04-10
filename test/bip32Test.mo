import Bip32 "../src/Bip32";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import TestUtils "./TestUtils";

type DerivationVector = {
  xPublicKey : Text;
  derivations : [{derivePath : Bip32.Path; serialized : ?Text}];
};

type ParseInvalidDataVector = {
  reason : Text;
  data : Text;
};

let derivationVectors: [DerivationVector] = [
  {
    xPublicKey = "xpub661MyMwAqRbcFtXgS5sYJABqqG9YLmC4Q1Rdap9gSE8NqtwybGhePY2gZ"
               # "29ESFjqJoCu1Rupje8YtGqsefD265TMg7usUDFdp6W1EGMcet8";
    derivations = [
      {
        derivePath = #text "m/0";
        serialized = ?("xpub68Gmy5EVb2BdFbj2LpWrk1M7obNuaPTpT5oh9QCCo5sRfqSHVYWex97WpDZz"
          # "szdzHzxXDAzPLVSwybe4uPYkSk4G3gnrPqqkV9RyNzAcNJ1");
      },
      {
        derivePath = #text "m/0/1";
        serialized = ?("xpub6AvUGrnEpfvJBbfx7sQ89Q8hEMPM65UteqEX4yUbUiES2jHfjexmfJoxCGSw"
          # "FMZiPBaKQT1RiKWrKfuDV4vpgVs4Xn8PpPTR2i79rwHd4Zr");
      },
      {
        derivePath = #text "m/0/1/2";
        serialized = ?("xpub6BqyndF6rhZqmgktFCBcapkwubGxPqoAZtQaYewJHXVKZcLdnqBVC8N6f6FS"
          # "HWUghjuTLeubWyQWfJdk2G3tGgvgj3qngo4vLTnnSjAZckv");
      },
      {
        derivePath = #array ([0, 1, 2]);
        serialized = ?("xpub6BqyndF6rhZqmgktFCBcapkwubGxPqoAZtQaYewJHXVKZcLdnqBVC8N6f6FS"
          # "HWUghjuTLeubWyQWfJdk2G3tGgvgj3qngo4vLTnnSjAZckv");
      },
      {
        derivePath = #text "m/0/1/2/2";
        serialized = ?("xpub6FHUhLbYYkgFQiFrDiXRfQFXBB2msCxKTsNyAExi6keFxQ8sHfwpogY3p3s1"
          # "ePSpUqLNYks5T6a3JqpCGszt4kxbyq7tUoFP5c8KWyiDtPp");
      },
      {
        derivePath = #text "m/0/1'/2/2";
        serialized = null;
      },
      {
        derivePath = #text "m/0/1/2/2/1000000000";
        serialized = ?("xpub6GX3zWVgSgPc5tgjE6ogT9nfwSADD3tdsxpzd7jJoJMqSY12Be6VQEFwDCp6"
          # "wAQoZsH2iq5nNocHEaVDxBcobPrkZCjYW3QUmoDYzMFBDu9");
      },
    ];
  },
  {
    xPublicKey = "xpub661MyMwAqRbcFW31YEwpkMuc5THy2PSt5bDMsktWQcFF8syAmRUapSCGu"
               # "8ED9W6oDMSgv6Zz8idoc4a6mr8BDzTJY47LJhkJ8UB7WEGuduB";
    derivations = [
      {
        derivePath = #array ([0]);
        serialized = ?("xpub69H7F5d8KSRgmmdJg2KhpAK8SR3DjMwAdkxj3ZuxV27CprR9LgpeyGmXUbC6"
          # "wb7ERfvrnKZjXoUmmDznezpbZb7ap6r1D3tgFxHmwMkQTPH");
      },
      {
        derivePath = #array ([0, 2147483647]);
        serialized = ?("xpub6ASAVgeWMg4pmutghzHG3BohahjwNwPmy2DgM6W9wGegtPrvNgjBwuZRD7hS"
          # "DFhYfunq8vDgwG4ah1gVzZysgp3UsKz7VNjCnSUJJ5T4fdD");
      },
      {
        derivePath = #array ([0, 2147483649]);
        serialized = null;
      },
      {
        derivePath = #array ([0, 2147483647, 1]);
        serialized = ?("xpub6CrnV7NzJy4VdgP5niTpqWJiFXMAca6qBm5Hfsry77SQmN1HGYHnjsZSujoH"
          # "zdxf7ZNK5UVrmDXFPiEW2ecwHGWMFGUxPC9ARipss9rXd4b");
      },
      {
        derivePath = #array ([0, 2147483647, 1, 2147483646]);
        serialized = ?("xpub6FL2423qFaWzHCvBndkN9cbkn5cysiUeFq4eb9t9kE88jcmY63tNuLNRzpHP"
          # "dAM4dUpLhZ7aUm2cJ5zF7KYonf4jAPfRqTMTRBNkQL3Tfta");
      },
      {
        derivePath = #array ([0, 2147483647, 1, 2147483646, 2]);
        serialized = ?("xpub6H7WkJf547AiSwAbX6xsm8Bmq9M9P1Gjequ5SipsjipWmtXSyp4C3uwzewed"
          # "GEgAMsDy4jEvNTWtxLyqqHY9C12gaBmgUdk2CGmwachwnWK");
      },
    ];
  },
  {
    xPublicKey = "xpub661MyMwAqRbcEZVB4dScxMAdx6d4nFc9nvyvH3v4gJL378CSRZiYmhRoP"
               # "7mBy6gSPSCYk6SzXPTf3ND1cZAceL7SfJ1Z3GC8vBgp2epUt13";
    derivations = [
      {
        derivePath = #text "0";
        serialized = ?("xpub68NZiKmAB8RzFjKx2J3PtxJEdMCB7UTYUjg4p29EoBvwdqCGKNjhnKSLBDxF"
          # "HjjVd1rBLGVCqKgiHdhqW11rpkV8MESRNyV51KGDLAoHtNQ");
      },
    ];
  },
  {
    xPublicKey = "xpub661MyMwAqRbcGczjuMoRm6dXaLDEhW1u34gKenbeYqAix21mdUKJyuyu5"
               # "F1rzYGVxyL6tmgBUAEPrEz92mBXjByMRiJdba9wpnN37RLLAXa";
    derivations = [
      {
        derivePath = #text "0";
        serialized = ?("xpub69AUMk3gsXB5iPXhnks7jE8yvUumnVydc8WVNa4XJHbMVPLzaX7R4zGMnb6P"
          # "a7dGkYcZLtZ91SpKTJMVMfwKKiNqvBJikZxi8QkSeTeAJZd");
      },
      {
        derivePath = #text "0/0";
        serialized = ?("xpub69u56b6HqhHBhLSrDGjJF3sdwGFD7sgkjQaM7uWWAcptW7UXVBQLaw53Eauf"
          # "JLNzZwLhVqNv9oHSh44MGVoWCxMW5cXbnPH53Ycw8tcuCWU");
      },
    ];
  },
];

let parseInvalidDataVectors = [
  {
    reason = "private keys are not supported";
    data = "xprv9s21ZrQH143K3QTDL4LXw2F7HEK3wJUD2nW2nRk4stbPy6cq3jPPqjiChkVvvNKmPGJxWUtg6LnF5kejMRNNU3TGtRBeJgk33yuGBxrMPHi";
  },
  {
    reason = "pubkey version / prvkey mismatch";
    data = "xpub661MyMwAqRbcEYS8w7XLSVeEsBXy79zSzH1J8vCdxAZningWLdN3zgtU6LBpB85b3D2yc8sfvZU521AAwdZafEz7mnzBBsz4wKY5fTtTQBm";
  },
  {
    reason = "invalid pubkey prefix 04";
    data = "xpub661MyMwAqRbcEYS8w7XLSVeEsBXy79zSzH1J8vCdxAZningWLdN3zgtU6Txnt3siSujt9RCVYsx4qHZGc62TG4McvMGcAUjeuwZdduYEvFn";
  },
  {
    reason = "invalid pubkey prefix 01";
    data = "xpub661MyMwAqRbcEYS8w7XLSVeEsBXy79zSzH1J8vCdxAZningWLdN3zgtU6N8ZMMXctdiCjxTNq964yKkwrkBJJwpzZS4HS2fxvyYUA4q2Xe4";
  },
  {
    reason = "zero depth with non-zero parent fingerprint";
    data = "xpub661no6RGEX3uJkY4bNnPcw4URcQTrSibUZ4NqJEw5eBkv7ovTwgiT91XX27VbEXGENhYRCf7hyEbWrR3FewATdCEebj6znwMfQkhRYHRLpJ";
  },
  {
    reason = "zero depth with non-zero index";
    data = "xpub661MyMwAuDcm6CRQ5N4qiHKrJ39Xe1R1NyfouMKTTWcguwVcfrZJaNvhpebzGerh7gucBvzEQWRugZDuDXjNDRmXzSZe4c7mnTK97pTvGS8";
  },
  {
    reason = "unknown extended key version";
    data = "DMwo58pR1QLEFihHiXPVykYB6fJmsTeHvyTp7hRThAtCX8CvYzgPcn8XnmdfHGMQzT7ayAmfo4z3gY5KfbrZWZ6St24UVf2Qgo6oujFktLHdHY4";
  },
  {
    reason = "unknown extended key version";
    data = "DMwo58pR1QLEFihHiXPVykYB6fJmsTeHvyTp7hRThAtCX8CvYzgPcn8XnmdfHPmHJiEDXkTiJTVV9rHEBUem2mwVbbNfvT2MTcAqj3nesx8uBf9";
  },
  {
    reason = "invalid pubkey 020000000000000000000000000000000000000000000000000000000000000007";
    data = "xpub661MyMwAqRbcEYS8w7XLSVeEsBXy79zSzH1J8vCdxAZningWLdN3zgtU6Q5JXayek4PRsn35jii4veMimro1xefsM58PgBMrvdYre8QyULY";
  },
];

let relativeDerivationVectors : [DerivationVector] = [
  {
    xPublicKey = "xpub6AvUGrnEpfvJBbfx7sQ89Q8hEMPM65UteqEX4yUbUiES2jHfjexmfJoxCGSw"
               # "FMZiPBaKQT1RiKWrKfuDV4vpgVs4Xn8PpPTR2i79rwHd4Zr";
    derivations = [
      {
        derivePath = #text "2";
        serialized = ?("xpub6BqyndF6rhZqmgktFCBcapkwubGxPqoAZtQaYewJHXVKZcLdnqBVC8N6f6FS"
          # "HWUghjuTLeubWyQWfJdk2G3tGgvgj3qngo4vLTnnSjAZckv");
      },
      {
        derivePath = #array ([2]);
        serialized = ?("xpub6BqyndF6rhZqmgktFCBcapkwubGxPqoAZtQaYewJHXVKZcLdnqBVC8N6f6FS"
          # "HWUghjuTLeubWyQWfJdk2G3tGgvgj3qngo4vLTnnSjAZckv");
      },
      {
        derivePath = #text "2/2";
        serialized = ?("xpub6FHUhLbYYkgFQiFrDiXRfQFXBB2msCxKTsNyAExi6keFxQ8sHfwpogY3p3s1"
          # "ePSpUqLNYks5T6a3JqpCGszt4kxbyq7tUoFP5c8KWyiDtPp");
      },
      {
        derivePath = #text "2'";
        serialized = null;
      },
      {
        derivePath = #text "2/2/1000000000";
        serialized = ?("xpub6GX3zWVgSgPc5tgjE6ogT9nfwSADD3tdsxpzd7jJoJMqSY12Be6VQEFwDCp6"
          # "wAQoZsH2iq5nNocHEaVDxBcobPrkZCjYW3QUmoDYzMFBDu9");
      },
    ];
  },
];

func testDerivations(vector : DerivationVector) {
  let xPublicKey = Bip32.parse(vector.xPublicKey, null);

  assert((do ? {
    assert(xPublicKey!.serialize() == vector.xPublicKey);
    for ({ derivePath; serialized } in vector.derivations.vals()) {
      switch(xPublicKey!.derivePath(derivePath)) {
        case (null) {
          assert(serialized == null);
        };
        case (?actualPublic) {
          assert(serialized == ?actualPublic.serialize());
        };
      };
    };
  }) != null);
};

func testParseInvalidData(vector : ParseInvalidDataVector) {
  let parsedKey = Bip32.parse(vector.data, null);
  switch (parsedKey) {
    case (null) {
      // good
    };
    case (_) {
      assert(false);
    };
  };
};

func testRelativeDerivation(vector : DerivationVector) {
  let xPublicKey = Bip32.parse(vector.xPublicKey, ?(#fingerprint([])));

  assert((do ? {
    assert(xPublicKey!.serialize() == vector.xPublicKey);
    for ({ derivePath; serialized } in vector.derivations.vals()) {
      switch(xPublicKey!.derivePath(derivePath)) {
        case (null) {
          assert(serialized == null);
        };
        case (?actualPublic) {
          assert(serialized == ?actualPublic.serialize());
        };
      };
    };
  }) != null);
};

Debug.print("Bip32");

let runTest = TestUtils.runTestWithDefaults;

runTest({
  title = "Derivation Vectors";
  fn = testDerivations;
  vectors = derivationVectors;
});

runTest({
  title = "Handling of Invalid Serializations";
  fn = testParseInvalidData;
  vectors = parseInvalidDataVectors;
});

runTest({
  title = "Relative derivation";
  fn = testRelativeDerivation;
  vectors = relativeDerivationVectors;
});
