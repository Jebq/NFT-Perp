#include "./lib/interface.mligo"
#include "./lib/utils.mligo"
#include "./lib/pool_functions.mligo"
#include "./lib/trading_function.mligo"
#include "./lib/clearing_house.mligo"

let main (action, s: parameter * storage): return =
  match action with
  | Create_pool p         -> ([]: operation list), create_pool (p, s)
  | Update_pool p         -> ([]: operation list), update_pool (p, s)
  | Long p                -> ([]: operation list), long (p, s)
  | Short p               -> ([]: operation list), short (p, s)
  | Close_long p          -> ([]: operation list), close_long (p, s)
  | Close_short p         -> ([]: operation list), close_short (p, s)
  | Update_floor_price p  -> ([]: operation list), update_floor_price (p, s)
  | Unlock_funds p        -> unlock_funds(p, s)
  | Default               -> ([]: operation list), default_ s
