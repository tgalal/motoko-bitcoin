let upstream =
  https://github.com/dfinity/vessel-package-set/releases/download/mo-0.6.20-20220131/package-set.dhall
let Package =
    { name : Text, version : Text, repo : Text, dependencies : List Text }

let
  -- This is where you can add your own packages to the package-set
additions = [
  { name = "sha"
  , repo = "https://github.com/tgalal/motoko-sha"
  , version = "a6d46445670407d51996c42892f696ed34d6296b"
  , dependencies = ["base"] : List Text
  }
] : List Package


let
  {- This is where you can override existing packages in the package-set

     For example, if you wanted to use version `v2.0.0` of the foo library:
     let overrides = [
         { name = "foo"
         , version = "v2.0.0"
         , repo = "https://github.com/bar/foo"
         , dependencies = [] : List Text
         }
     ]
  -}
  overrides =
    [] : List Package

in  upstream # additions # overrides
