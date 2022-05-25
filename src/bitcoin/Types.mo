module {
  // The type of Bitcoin network.
  public type Network = {
    #Bitcoin;
    #Regtest;
    #Testnet;
    #Signet;
  };

  public type P2PkhAddress = Text;
};
