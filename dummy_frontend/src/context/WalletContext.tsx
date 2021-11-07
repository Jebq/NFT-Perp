import React, { useState, Dispatch, SetStateAction } from "react";
import { TezosToolkit } from "@taquito/taquito";
import {
  NetworkType,
  BeaconEvent,
  defaultEventCallbacks
} from "@airgap/beacon-sdk";

export interface WalletContextData {
  tezos: any;
  publicToken: string | null;
  userAddress: string;
  userBalance: number;
  wallet: any;
  setTezos: Dispatch<SetStateAction<TezosToolkit>>;
  setPublicToken: Dispatch<SetStateAction<string | null>>;
  setUserAddress: Dispatch<SetStateAction<string>>;
  setUserBalance: Dispatch<SetStateAction<number>>;
  setWallet: Dispatch<SetStateAction<any>>;
  setupWallet: Dispatch<SetStateAction<any>>;
  connectWallet: Dispatch<SetStateAction<any>>;
  disconnectWallet: Dispatch<SetStateAction<any>>;
}
 
export const walletcontextDataDefaultValue: WalletContextData = {
  tezos: null,
  publicToken: null,
  userAddress: '',
  userBalance: 0,
  wallet: null,
  setTezos: () => {},
  setPublicToken: () => {},
  setUserAddress: () => {},
  setUserBalance: () => {},
  setWallet: () => {},
  setupWallet: () => {},
  connectWallet: () => {},
  disconnectWallet: () => {}
}
 
export const WalletContext = React.createContext<WalletContextData>(walletcontextDataDefaultValue);

export function useWalletContextValue(toolkit: TezosToolkit): WalletContextData {
  const [tezos, setTezos] = useState(toolkit);
  const [publicToken, setPublicToken] = useState<string | null>("");
  const [wallet, setWallet] = useState<any>(null);
  const [userAddress, setUserAddress] = useState<string>("");
  const [userBalance, setUserBalance] = useState<number>(0);
  
  const setupWallet = async (userAddress: string): Promise<void> => {
    setUserAddress(userAddress);
    // updates balance
    const balance = await tezos.tz.getBalance(userAddress);
    setUserBalance(balance.toNumber());
  };

  const connectWallet = async (): Promise<void> => {
    try {
      await wallet.requestPermissions({
        network: {
          type: NetworkType.GRANADANET,
          rpcUrl: "https://api.tez.ie/rpc/granadanet"
        }
      });
      // gets user's address
      const userAddress = await wallet.getPKH();
      await setupWallet(userAddress);
    } catch (error) {
      console.log(error);
    }
  };

  const disconnectWallet = async (): Promise<void> => {
    //window.localStorage.clear();
    setUserAddress("");
    setUserBalance(0);
    // setWallet(null);
    const tezosTK = new TezosToolkit("https://api.tez.ie/rpc/granadanet");
    setTezos(tezosTK);
    setPublicToken(null);
    console.log("disconnecting wallet");
    if (wallet) {
      await wallet.client.removeAllAccounts();
      await wallet.client.removeAllPeers();
      await wallet.client.destroy();
    }
  };

  return {
    tezos,
    publicToken,
    userAddress,
    userBalance,
    wallet,
    setTezos,
    setPublicToken,
    setUserAddress,
    setUserBalance,
    setWallet,
    setupWallet,
    connectWallet,
    disconnectWallet
  }
}