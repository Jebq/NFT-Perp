# Marketplace Contract

Live on granadanet: https://better-call.dev/granadanet/KT1TcJUk4aZNyozWfKh8vKq6g8dZAAJK2y6S/

Inspired and forked from https://github.com/claudebarde/fa2-token-with-built-in-dex.

Marketplace contract.

Entrypoints:
%Update_operators
%Balance_of
%Sell
%Buy
%Lock
%Burn

## How to

You can compile the contract and storage to michelson using `compile_contract.sh` and `compile_storage.sh`.
If you want to deploy your contract on mainnet or test, please use `deploy_contract.sh` after setting up tezos-client (and update the origination address in the script).
