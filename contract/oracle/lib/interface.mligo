type token_id = nat

type storage =
{
  price         : (token_id, tez) big_map;
  source        : address;
  admin         : address;
}

type set_price_params =
[@layout:comb]
{
  token_id          : token_id;
  floor_price       : tez;
  contract_address  : address;
}

type parameter =
| SetPrice      of set_price_params
| SetSource     of address

type return = operation list * storage
