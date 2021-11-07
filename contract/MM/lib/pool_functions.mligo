let create_pool (p, s: create_pool_params * storage): storage =
  let {
    token_id = token_id;
    quote_asset_amt = quote_asset_amt;
    floor_price = floor_price
  } = p in
  if Big_map.mem p.token_id s.token_ledger
    then (failwith "POOL ALREADY EXISTS": storage)
  else
    let new_pool_storage : pool_storage = {
      fee_ratio = 500n;
      spread_ratio = 250n;
      quote_asset_amt = quote_asset_amt * 100_000_000n;
      base_asset_amt = quote_asset_amt * floor_price / 1tez * 100_000_000n;
      longs = (Map.empty: (address, int) map);
      shorts = (Map.empty: (address, int) map);
      total_long = 0;
      total_short = 0;
    } in
    let new_pool_ledger = Big_map.add (token_id) new_pool_storage s.pool_ledger in
    let new_token_ledger = Big_map.add (token_id) token_id s.token_ledger in
    { 
      s with 
        pool_ledger = new_pool_ledger;
        token_ledger = new_token_ledger;
    }


let update_pool(p, s: update_pool_params * storage): storage =
  let { token_id = token_id; quote_asset_amt = quote_asset_amt} = p in
  if not Big_map.mem p.token_id s.token_ledger
  then (failwith "POOL_UNDEFINED": storage)
  else
    let pool_id: pool_id = Big_map.find token_id s.token_ledger in
    let pool_info: pool_storage = Big_map.find pool_id s.pool_ledger in
    let new_quote_amt = pool_info.quote_asset_amt + (quote_asset_amt * 100_000_000n) in
    let const_curve = pool_info.quote_asset_amt * pool_info.base_asset_amt in
    let new_base_asset_amt = const_curve / new_quote_amt in
    let _base_asset_to_remove = pool_info.base_asset_amt - new_base_asset_amt in 
    let new_pool_storage : pool_storage = {
      fee_ratio = pool_info.fee_ratio;
      spread_ratio = pool_info.spread_ratio;
      quote_asset_amt = new_quote_amt;
      base_asset_amt = new_base_asset_amt;
      longs = pool_info.longs;
      shorts = pool_info.shorts;
      total_long = pool_info.total_long;
      total_short = pool_info.total_short;  
    } in
    let new_pool_ledger = Big_map.update pool_id (Some (new_pool_storage)) s.pool_ledger in
    { 
      s with 
        pool_ledger = new_pool_ledger;
    }