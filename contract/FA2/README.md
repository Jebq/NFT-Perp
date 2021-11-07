# FA2 Contract

Live on granadanet: https://better-call.dev/granadanet/KT1LoM3h1ViVv6spHbSPm8Hrw8xpnA82mpEe/

Inspired and forked from https://github.com/claudebarde/fa2-token-with-built-in-dex.

FA2 token contract.

Entrypoints:
%Transfer
%Update_operators
%Balance_of
%Mint
%Burn

## How to

You can compile the contract and storage to michelson using `compile_contract.sh` and `compile_storage.sh`.
If you want to deploy your contract on mainnet or test, please use `deploy_contract.sh` after setting up tezos-client (and update the origination address in the script).
