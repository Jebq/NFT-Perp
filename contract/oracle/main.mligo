#include "./lib/interface.mligo"
#include "./lib/oracle_functions.mligo"

let main (action, s: parameter * storage): return =
  match action with
  | SetPrice p    -> set_price (p, s)
  | SetSource p   -> ([]: operation list), set_source (p, s)
