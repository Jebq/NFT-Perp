#include "./lib/interface.mligo"
#include "./lib/transfer.mligo"
#include "./lib/update_operators.mligo"
#include "./lib/balance_of.mligo"
#include "./lib/mint.mligo"
#include "./lib/burn.mligo"

let main (action, s: parameter * storage): return =
  match action with
  | Transfer p          -> ([]: operation list), transfer (p, s)
  | Update_operators p  -> ([]: operation list), update_operators (p, s)
  | Balance_of p        -> balance_of (p, s)
  | Mint p              -> ([]: operation list), mint (p, s)
  | Burn p              -> ([]: operation list), burn (p, s)