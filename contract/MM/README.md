# Exchange Contract

Live on granadanet: https://better-call.dev/granadanet/KT19T3iqWALWXRM46ARnVWVBqtrFLxy5kCdz/operations

Marketplace contract.

Entrypoints:
%Create_pool
%Update_pool
%Long
%Short
%Close_long
%Close_short
%Update_floor_price
%Unlock_funds
%Default


## How to

You can compile the contract and storage to michelson using `compile_contract.sh` and `compile_storage.sh`.
If you want to deploy your contract on mainnet or test, please use `deploy_contract.sh` after setting up tezos-client (and update the origination address in the script).
