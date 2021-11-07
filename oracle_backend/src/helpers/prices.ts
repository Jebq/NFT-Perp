import { TezosToolkit } from "@taquito/taquito";
import { InMemorySigner } from '@taquito/signer'

export const fetchPrice = async (): Promise<any[]> => {
    const rpc: string = "https://api.tez.ie/rpc/granadanet" 
    const providerAddress: string = "KT1UwWZyyNLdAmzP3Q3MLob7cHpdVNEjHyto"

    const tezos = new TezosToolkit(rpc);
    const contract = await tezos.contract.at(providerAddress)
    const _storage: any = await contract.storage();
    const token = await _storage.token_metadata.get(0);
    const price = await token.token_floor_price['c'];

    return price
}

export const updatePrice = async (floor_price: any) => {
    const email: string = "lnjgowca.lnpnvbzf@tezos.example.org" 
    const password: string = "ciNtQEpydF"
    const mnemonic: string = "chronic viable nothing project prepare sure sad fresh room throw shadow add plug junior ramp"
    const rpc: string = "https://api.tez.ie/rpc/granadanet"
    const oracleAddress: string = "KT1MiaYhEWdyeyn8USZzW54qCgins4NiLpZu"

    const signer = InMemorySigner.fromFundraiser(email, password, mnemonic);
    console.log('Signed')
    
    const tezos = new TezosToolkit(rpc);
    tezos.setProvider({ rpc, signer })
    
    console.log('Get contract..')
    const contract = await tezos.contract.at(oracleAddress)

    console.log('Send price...')
    const operation = await contract.methods.setPrice(0, floor_price, "KT19T3iqWALWXRM46ARnVWVBqtrFLxy5kCdz").send()
    await operation.confirmation()
    console.log('Done')
}