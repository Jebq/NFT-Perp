import React, { useState, useEffect, useContext } from 'react';
import styled from 'styled-components';

import {WalletContext} from '../context/WalletContext';

type MarketPlaceInterface = {
  };

const MPLayout = styled.div`
  display: flex;
  flex-direction: column;
`;

export default function MarketPlace(){

  const { userAddress, tezos } = useContext(WalletContext);

  const [contract, setContract] = useState<any>(undefined);

  const [token, setToken] = useState({
    address: 'KT1LoM3h1ViVv6spHbSPm8Hrw8xpnA82mpEe',
    id: '',
    amount: '',
    price: '',
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
    setup("KT1UwWZyyNLdAmzP3Q3MLob7cHpdVNEjHyto");
  }, [])

  const sell = async (): Promise<void> => {
    try {
        if (token.address.length > 0) {
            const op = await contract.methods.sell(token.address, token.amount, token.id, token.price).send();
            await op.confirmation();
        }
    } catch (error) {
      console.log('error');
      console.log(error);
    } 
  };

  const buy = async (): Promise<void> => {
    try {
        if (token.address.length > 0) {
            const op = await contract.methods.buy(token.address, token.amount, token.id).send();
            await op.confirmation();
        }
    } catch (error) {
      console.log('error');
      console.log(error);
    } 
  };

  const lock = async (): Promise<void> => {
    try {
        if (token.address.length > 0) {
            const op = await contract.methods.lock(token.address, token.id, token.amount, token.price).send();
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
    <MPLayout>
      <h1>MarketPlace</h1>
      <a href='https://better-call.dev/granadanet/KT1UwWZyyNLdAmzP3Q3MLob7cHpdVNEjHyto/operations' target='_blank'>KT1UwWZyyNLdAmzP3Q3MLob7cHpdVNEjHyto</a>
      <br />
      <div>
        <div>
          Token Address:
            <input type="text" name="address" value={token.address} 
            onChange={handleChange}/>
        </div>
        <div>
            Token Amount:
            <input type="text" name="amount"
            value={token.id}
            onChange={handleChange}/>
        </div>
        <div>
            Token ID:
            <input type="text" name="id" value={token.id} 
            onChange={handleChange}/>
        </div>
        <div>
            Price:
            <input type="text" name="price"
            value={token.price}
            onChange={handleChange}/>
        </div>
      </div>
      <button onClick={sell}>
      Sell
      </button>
      <br />
      <div>
        <div>
            Token address:
            <input type="text" name="metadata" value={token.address} 
            onChange={handleChange}/>
        </div>
        <div>
            Token Amount:
            <input type="text" name="amount"
            value={token.amount}
            onChange={handleChange}/>
        </div>
        <div>
            Token ID:
            <input type="text" name="id"
            value={token.id}
            onChange={handleChange}/>
        </div>
      </div>
      <button onClick={buy}>
      Buy
      </button>
      <br />
      <div>
        <div>
            Token Address:
            <input type="text" name="metadata" value={token.address} 
            onChange={handleChange}/>
        </div>
        <div>
            Token Amount:
            <input type="text" name="amount"
            value={token.amount}
            onChange={handleChange}/>
        </div>
        <div>
            Token ID:
            <input type="text" name="id"
            value={token.id}
            onChange={handleChange}/>
        </div>
        <div>
            Floor price:
            <input type="text" name="price"
            value={token.price}
            onChange={handleChange}/>
        </div>
      </div>
      <button onClick={lock}>
      Lock
      </button>
    </MPLayout>
  );
}