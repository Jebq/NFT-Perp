import React, { useContext, useEffect, Dispatch, SetStateAction } from "react";
import { BeaconWallet } from "@taquito/beacon-wallet";

import {
  NetworkType,
  BeaconEvent,
  defaultEventCallbacks
} from "@airgap/beacon-sdk";
import styled from 'styled-components';

import Button from "./Button";
import { WalletContext } from '../context/WalletContext';

const WalletFrameLayout = styled.div`
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  padding: 4px 0px 0px 0px;
  margin-top: 0px;
  margin-bottom: 16px;
  width: 100%;
  float: right;
  background-color: #3d3d5c;
  border-radius: 20px;
`;

const WalletInfo = styled.div`
  display: flex;
  flex-direction: row;
  flex-grow: 1;
  justify-content: space-between;
  align-items: center;
  margin-left: 12px;
  margin-right: 24px;
  font-size: 1rem;
  color: white;
  a {
    color: inherit;
    text-decoration: inherit;
  } 
`;

const WalletAddress = styled.div`
  border: 3px solid #33334d;
  border-radius: 12px;
  padding: 12px;

  :hover {
    text-shadow: 0px 0px 8px #fff;
    border: 3px solid grey;
  }
`;

const WalletAmount = styled.div`
`;

interface WalletFrameProps {
}

export default function WalletFrame({
}: WalletFrameProps) {

  const {
    tezos,
    publicToken,
    userAddress,
    userBalance,
    setPublicToken,
    setWallet,
    setupWallet,
    connectWallet,
    disconnectWallet
  } = useContext(WalletContext);

  useEffect(() => {
    (async () => {
      // creates a wallet instance
      const wallet = new BeaconWallet({
        name: "Taquito Boilerplate",
        preferredNetwork: NetworkType.GRANADANET,
        disableDefaultEvents: true, // Disable all events / UI. This also disables the pairing alert.
        eventHandlers: {
          // To keep the pairing alert, we have to add the following default event handlers back
          [BeaconEvent.PAIR_INIT]: {
            handler: defaultEventCallbacks.PAIR_INIT
          },
          [BeaconEvent.PAIR_SUCCESS]: {
            handler: data => setPublicToken(data.publicKey)
          }
        }
      });
      tezos.setWalletProvider(wallet);
      setWallet(wallet);
      // checks if wallet was connected before
      const activeAccount = await wallet.client.getActiveAccount();
      if (activeAccount) {
        const userAddress = await wallet.getPKH();
        await setupWallet(userAddress);
      }
    })();
  }, []);

  if (userAddress && !isNaN(userBalance)) {
    return (
      <WalletFrameLayout>
        <WalletInfo>
          <WalletAmount>
            {(userBalance / 1000000).toLocaleString("en-US")} ꜩ
          </WalletAmount>
            <a 
              href={"https://tzkt.io/" + userAddress}
              target='_blank'>
          <WalletAddress>
            {userAddress.substring(0, 7) + '...' + userAddress.substring(userAddress.length - 6)}
          </WalletAddress>
            </a>
        </WalletInfo>
        <Button
          text="Disconnect wallet"
          onClick={disconnectWallet}
        />
      </WalletFrameLayout>
    )
  } else if (publicToken && (!userAddress || isNaN(userBalance))) {
      return (
        <WalletFrameLayout>
          <WalletInfo>
            <p>Tezos</p>
          </WalletInfo>
          <Button
            text="Connect wallet"
            onClick={connectWallet}
          />
        </WalletFrameLayout>
    )
  } else if (!publicToken && !userAddress && !userBalance) {
    return (
      <WalletFrameLayout>
        <WalletInfo>
          <p>Tezos</p>
        </WalletInfo>
        <Button
          text="Connect wallet"
          onClick={connectWallet}
        />
      </WalletFrameLayout>
    );
  } else {
    return (
      <WalletFrameLayout>
        An error has occured.
      </WalletFrameLayout>
    );
  }
}