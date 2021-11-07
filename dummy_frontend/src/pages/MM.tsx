import React, { useState, useEffect, useContext } from 'react';
import styled from 'styled-components';

import { char2Bytes } from "@taquito/utils";
import {WalletContext} from '../context/WalletContext';

type MMInterface = {
  };

const MMLayout = styled.div`
  display: flex;
  flex-direction: column;
  border-left: 1px solid black;
  padding-left: 5%;
`;

const TradingLayout = styled.div`
  display: flex;
  flex-direction: row;
`;

const TradingSection = styled.div`
  display: flex;
  flex-direction: column;
`;

export default function MM(){

  const { userAddress, tezos } = useContext(WalletContext);

  const [contract, setContract] = useState<any>(undefined);

  const [amount, setAmount] =useState({
    deposit: 0,
    unlock: 0
  });

  const [token, setToken] = useState({
    id: '',
    amount: '',
    floor_price: ''
  });

  const [trading, setTrading] = useState({
    long: '',
    short: '',
    close_long: '',
    close_short: ''
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
    setup("KT19T3iqWALWXRM46ARnVWVBqtrFLxy5kCdz");
  }, [])

  const create_pool = async (): Promise<void> => {
    try {
      const op = await contract.methods.create_pool(token.id, token.amount, token.floor_price).send();
      await op.confirmation();
    } catch (error) {
      console.log('error');
      console.log(error);
    } 
  };

  const deposit = async (): Promise<void> => {
    try {
      const op = await contract.methods.default(0).send({ amount: amount.deposit });
      await op.confirmation();
    } catch (error) {
      console.log('error');
      console.log(error);
    } 
  };  
  
  const unlock = async (): Promise<void> => {
    try {
      const op = await contract.methods.unlock_funds(amount.unlock * 1000000).send();
      await op.confirmation();
    } catch (error) {
      console.log('error');
      console.log(error);
    } 
  };

  const long = async (): Promise<void> => {
    try {
      const op = await contract.methods.long(0, trading.long).send();
      await op.confirmation();
    } catch (error) {
      console.log('error');
      console.log(error);
    } 
  };

  const short = async (): Promise<void> => {
    try {
      const op = await contract.methods.short(0, trading.short).send();
      await op.confirmation();
    } catch (error) {
      console.log('error');
      console.log(error);
    } 
  };
  const close_long = async (): Promise<void> => {
    try {
      const op = await contract.methods.close_long(0, trading.close_long).send();
      await op.confirmation();
    } catch (error) {
      console.log('error');
      console.log(error);
    } 
  };

  const close_short = async (): Promise<void> => {
    try {
      const op = await contract.methods.close_short(0, trading.close_short).send();
      await op.confirmation();
    } catch (error) {
      console.log('error');
      console.log(error);
    } 
  };

  function handleChangeAmount(e: any) {
    const { name, value } = e.target;
    setAmount(amount => ({ ...amount, [name]: value }));
  }

  function handleChange(e: any) {
    const { name, value } = e.target;
    setToken(token => ({ ...token, [name]: value }));
  }

  function handleChangeTrading(e: any) {
    const { name, value } = e.target;
    setTrading(trading => ({ ...trading, [name]: value }));
  }

  return(
    <MMLayout>
      <h1>Exchange</h1>
      <a href='https://better-call.dev/granadanet/KT19T3iqWALWXRM46ARnVWVBqtrFLxy5kCdz/operations' target='_blank'>KT19T3iqWALWXRM46ARnVWVBqtrFLxy5kCdz</a>
      <br />
      <h2>Clearing House</h2>
      <TradingLayout>
        <TradingSection>
          <div>
            <h3>Deposit</h3>
            <div>
                Tezos Amount (tezos):
                <input type="text" name="deposit" value={amount.deposit} 
                onChange={handleChangeAmount}/>
            </div>
          </div>
          <button onClick={deposit}>
          Deposit
          </button>
        </TradingSection>
        <TradingSection>
          <div>
            <h3>Unlock</h3>
            <div>
                Tezos Amount (tezos):
                <input type="text" name="unlock" value={amount.unlock} 
                onChange={handleChangeAmount}/>
            </div>
          </div>
          <button onClick={unlock}>
          Unlock funds
          </button>
        </TradingSection>
      </TradingLayout>
      <div>
        <h2> Pools </h2>
        <h3>Create Pool</h3>
        <div>
            Token ID:
            <input type="text" name="id" value={token.id} 
            onChange={handleChange}/>
        </div>
        <div>
            Token Amount:
            <input type="text" name="amount" value={token.amount} 
            onChange={handleChange}/>
        </div>
        <div>
            Token Floor Price (mutez):
            <input type="text" name="floor_price" value={token.floor_price} 
            onChange={handleChange}/>
        </div>
      </div>
      <button onClick={create_pool}>
      Create Pool
      </button>
      <h2>Trading (On pool 0 by default)</h2>
      <TradingLayout>
        <TradingSection>
          <h3>Long</h3>
          <div>
              Amount (tezos):
              <input type="text" name="long" value={trading.long} 
              onChange={handleChangeTrading}/>
          </div>
          <button onClick={long}>
          Long
          </button>
          <h3>Close</h3>
          <div>
              Amount (tezos):
              <input type="text" name="close_long" value={trading.close_long} 
              onChange={handleChangeTrading}/>
          </div>
          <button onClick={close_long}>
          Close Long
          </button>
        </TradingSection>
        <TradingSection>
          <h3>Short</h3>
          <div>
              Short (tezos):
              <input type="text" name="short" value={trading.short} 
              onChange={handleChangeTrading}/>
          </div>
          <button onClick={short}>
          Short
          </button>
          <h3>Close</h3>
          <div>
              Amount (tezos):
              <input type="text" name="close_short" value={trading.close_short} 
              onChange={handleChangeTrading}/>
          </div>
          <button onClick={close_short}>
          Close Short
          </button>
        </TradingSection>
      </TradingLayout>
    </MMLayout>
  );
}