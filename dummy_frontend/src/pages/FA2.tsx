import React, { useState, useEffect, useContext } from 'react';
import styled from 'styled-components';

import { char2Bytes } from "@taquito/utils";

import {WalletContext} from '../context/WalletContext';

type FA2Interface = {
  };

const FA2Layout = styled.div`
  display: flex;
  flex-direction: column;
  border-right: 1px solid black;
  padding-right: 5%;
`;

export default function FA2(){

  const { userAddress, tezos } = useContext(WalletContext);

  const [contract, setContract] = useState<any>(undefined);

  const [token, setToken] = useState({
    metadata: '',
    id: '',
    amount: ''
  });

  useEffect(() => {
    const setup = async (contractAddress: string): Promise<void> => {
      try {
        const _contract = await tezos.wallet.at(contractAddress);
        setContract(_contract);
        console.log(_contract);
      } catch (error) {
        throw error;
      }
    };
    setup("KT1LoM3h1ViVv6spHbSPm8Hrw8xpnA82mpEe");
  }, [])

  const mint = async (): Promise<void> => {
    try {
        if (token.metadata.length > 0) {
            const op = await contract.methods.mint(userAddress, token.amount, token.id, char2Bytes(JSON.stringify(token.metadata))).send();
            await op.confirmation();
        }
    } catch (error) {
      console.log('error');
      console.log(error);
    } 
  };

  function handleChange(e: any) {
    const { name, value } = e.target;
    setToken(token => ({ ...token, [name]: value }));
  }

  return(
    <FA2Layout>
      <h1>FA2</h1>
      <a href='https://better-call.dev/granadanet/KT1LoM3h1ViVv6spHbSPm8Hrw8xpnA82mpEe/operations' target='_blank'>KT1LoM3h1ViVv6spHbSPm8Hrw8xpnA82mpEe</a>
      <br />
      <div>
        <div>
            Metadata:
            <input type="text" name="metadata" value={token.metadata} 
            onChange={handleChange}/>
        </div>
        <div>
            Token ID:
            <input type="text" name="id"
            value={token.id}
            onChange={handleChange}/>
        </div>
        <div>
            Amount:
            <input type="text" name="amount"
            value={token.amount}
            onChange={handleChange}/>
        </div>
      </div>
      <button onClick={mint}>
      Mint
      </button>
    </FA2Layout>
  );
}