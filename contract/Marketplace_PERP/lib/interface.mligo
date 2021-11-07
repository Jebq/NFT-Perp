type token_id = nat

(*
    STORAGE
*)

type ledger = ((address * token_id), nat) big_map

type token_metadata_val =
[@layout:comb]
{
    token_id            : token_id;
    token_owner         : address;
    token_price         : tez;
    token_floor_price   : tez;
}

type perp_metadata_val =
[@layout:comb]
{
    token_id            : token_id;
    token_owner         : address;
}

type token_metadata = (token_id, token_metadata_val) big_map
type perp_metadata = (token_id, perp_metadata_val) big_map
type perp_total_supply = (token_id, nat) big_map

type storage =
{
    ledger              : ledger;
    perp_ledger         : ledger;
    metadata            : (string, bytes) big_map;
    token_metadata      : token_metadata;
    perp_metadata       : perp_metadata;
    operators           : (((address * address) * token_id), unit) big_map; // key is user * operator * token_id
    admin               : address;
    total_supply        : nat;
    perp_total_supply   : perp_total_supply;
}

(*
    UPDATE OPERATORS PARAMS
*)

type action_operator_param =
[@layout:comb]
{
    owner   : address;
    operator: address;
    token_id: token_id
}

type update_operators_param =
| Add_operator of action_operator_param
| Remove_operator of action_operator_param

(*
    BALANCE OF PARAMS
*)

type balance_of_request =
[@layout:comb]
{
    owner   : address;
    token_id: token_id;
}

type balance_of_callback_param =
[@layout:comb]
{
    request: balance_of_request;
    balance: nat;
}

type balance_of_param =
[@layout:comb]
{
    requests: balance_of_request list;
    callback: (balance_of_callback_param list) contract;
}

(*
    LOCK PARAMS
*)

type transfer_to =
[@layout:comb]
{
    to_     : address;
    token_id: token_id;
    amount  : nat;
}

type fa2_contract_transfer_type =
[@layout:comb]
{
    from_   : address;
    txs     : transfer_to list;
}

type lock_params =
[@layout:comb]
{
    destination : address;
    token_id    : token_id;
    amount      : nat;
    floor_price : tez;
}

(*
    UNLOCK PARAMS
*)

// type unlock_params =
// [@layout:comb]
// {
//     destination : (fa2_contract_transfer_type contract);
//     token_id    : token_id;
// }

type unlock_params = 
[@layout:comb]
{
    owner       : address;
    amount      : nat;
    token_id    : token_id;
}

(*
    SELL PRAMS
*)

type sell_params =
[@layout:comb]
{
    destination : address;
    amount      : nat;
    token_id    : token_id;
    price       : tez;
}

(*
    BUY PRAMS
*)

type buy_params =
[@layout:comb]
{
    destination : address;
    amount      : nat;
    token_id    : token_id;
}

type parameter =
| Update_operators              of update_operators_param list
| Balance_of                    of balance_of_param
| Sell                          of sell_params
| Buy                           of buy_params
| Lock                          of lock_params
| Burn                          of unlock_params

type return = operation list * storage