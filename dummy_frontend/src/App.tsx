import React from "react";
import { TezosToolkit } from "@taquito/taquito";
import styled from 'styled-components'  ;

import "./App.css";

import {WalletContext, useWalletContextValue} from '../src/context/WalletContext';

import FA2 from './pages/FA2';
import MarketPlace from './pages/MarketPlace';
import MM from './pages/MM';
import WalletFrame from "./components/WalletFrame";
import Footer from "./components/Footer";

const MainBox = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 100%;
`;

const TopFrame = styled.div`
  margin-top: 0px;
  width: 500px;
`;

const BottomFrame = styled.div`
  width: 100%;
  margin-top: 0px;
  display: flex;
  flex-direction: row;
  justify-content: space-evenly;
`;

const Title = styled.h1`
  text-align: left;
  font-weight: lighter;
  color: #DCDCDC;
`;

export default function App() {
  const contractAddress = "KT1XH3mxkzx9fJk1skyKw7KQAkJUDHWna5yi";

  return (
    <WalletContext.Provider value={useWalletContextValue(new TezosToolkit("https://api.tez.ie/rpc/granadanet"))}>
        <MainBox>
          <TopFrame>
            <WalletFrame />
          </TopFrame>
          <BottomFrame>
            <FA2 />
            <MarketPlace />
            <MM />
          </BottomFrame>
          <Footer />
        </MainBox>
    </WalletContext.Provider>
  );
};
