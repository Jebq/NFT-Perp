type token_id = nat

(*
    STORAGE
*)

type ledger = ((address * token_id), nat) big_map

type token_metadata_val =
[@layout:comb]
{
    token_id    : token_id;
    token_info  : (string, bytes) map;
}
type token_metadata = (token_id, token_metadata_val) big_map

type storage =
{
    ledger              : ledger;
    metadata            : (string, bytes) big_map;
    token_metadata      : token_metadata;
    operators           : (((address * address) * token_id), unit) big_map; // key is user * operator * token_id
    admin               : address;
    total_supply        : nat;
}

(*
    TRANSFER PARAMS
*)

type transfer_to =
[@layout:comb]
{
    to_     : address;
    token_id: token_id;
    amount  : nat;
}

type transfer_param = 
[@layout:comb]
{
    from_   : address;
    txs     : transfer_to list;
}

(*
    UPDATE OPERATORS PARAMS
*)

type action_operator_param =
[@layout:comb]
{
    owner   : address;
    operator: address;
    token_id: token_id;
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
    MINT PARAMS
*)

type mint_params =
[@layout:comb]
{
    recipient       : address;
    amount          : nat;
    token_id        : token_id;
    link_to_metadata: bytes;
}

(*
    BURN PARAMS
*)

type burn_params =
[@layout:comb]
{
    owner       : address;
    amount      : nat;
    token_id    : token_id;
}

type parameter =
| Transfer                      of transfer_param list
| Update_operators              of update_operators_param list
| Balance_of                    of balance_of_param
| Mint                          of mint_params
| Burn                          of burn_params

type return = operation list * storage
