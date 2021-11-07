type pool_id  = nat
type token_id = nat

type trade_type = (address, int) map

type pool_storage =
[@layout:comb] 
{
  fee_ratio       : nat;
  spread_ratio    : nat;
  quote_asset_amt : nat;
  base_asset_amt  : nat;
  longs           : trade_type;
  shorts          : trade_type;
  total_long      : int;
  total_short     : int;      
}

type storage =
{
  token_ledger  : (token_id, pool_id) big_map;
  pool_ledger   : (pool_id, pool_storage) big_map;
  clearing_house: (address, int) big_map;
  admin         : address;
}

type create_pool_params =
[@layout:comb]
{
  token_id        : token_id;
  quote_asset_amt : nat;
  floor_price     : tez;
}

type update_pool_params =
[@layout:comb]
{
  token_id        : token_id;
  quote_asset_amt : nat;
}

type trade_params = 
[@layout:comb]
{
  pool_id     : pool_id;
  base_asset  : nat;
}

type close_params = 
[@layout:comb]
{
  pool_id       : pool_id;
  quote_asset   : nat;
}

type update_floor_price_params = 
[@layout:comb]
{
  token_id      : pool_id;
  floor_price   : tez;
}

type unlock_funds_params = 
[@layout:comb]
{
  amt      : tez;
}

type parameter =
| Create_pool         of create_pool_params
| Update_pool         of update_pool_params
| Long                of trade_params
| Short               of trade_params
| Close_long          of close_params
| Close_short         of close_params
| Update_floor_price  of update_floor_price_params
| Unlock_funds        of unlock_funds_params
| Default             of unit

type return = operation list * storage
