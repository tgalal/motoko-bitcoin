import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";

// A mini test runner to facilitate debugging and benchmarking.
module {
  // A test is expressed as a vector of primitive data type indicating inputs
  // and outputs of a specific test subject.
  // `fn` is a function that operates on a single data item in the test vector.
  type Test<T> = {
    title : Text;
    fn : (T) -> ();
    vectors : [T];
  };

  // Test-specific options
  // count describes the number of times to run the test. This is mainly
  // intended for facilitating benchmarking.
  // `verbose` makes the test runner indicate the item it is operating on. This
  // can be used to determine which failing 
  type TestOptions = {
    count: Nat;
    verbose : Bool;
  };

  public let defaultOptions : TestOptions = {
    count = 1;
    verbose = false;
  };

  // Run a given test with the given options
  public func runTest<T>(test: Test<T>, options : TestOptions) {
    Debug.print("  " # test.title);
    for (i in Iter.range(0, options.count - 1)) {
      for (vectorIndex in Iter.range(0, test.vectors.size() - 1)) {
        if (options.verbose) {
          Debug.print("    Test Case #" # Nat.toText(vectorIndex + 1));
        };
        test.fn(test.vectors[vectorIndex]);
      };
    };
  };

  // Run a given test with the defailt options
  public func runTestWithDefaults<T>(test: Test<T>) {
    runTest(test, defaultOptions);
  };
};
