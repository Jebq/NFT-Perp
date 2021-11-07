#include "./lib/interface.mligo"
#include "./lib/utils.mligo"
#include "./lib/update_operators.mligo"
#include "./lib/balance_of.mligo"
#include "./lib/lock.mligo"
#include "./lib/burn.mligo"
#include "./lib/sell.mligo"
#include "./lib/buy.mligo"

let main (action, s: parameter * storage): return =
  match action with
  | Update_operators p  -> ([]: operation list), update_operators (p, s)
  | Balance_of p        -> balance_of (p, s)
  | Sell p              -> sell (p, s)
  | Buy p               -> buy (p, s)
  | Lock p              -> lock (p, s)
  | Burn p              -> ([]: operation list), burn (p, s)