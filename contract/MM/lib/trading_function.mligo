let long(p, s: trade_params * storage): storage =
  if not Big_map.mem Tezos.sender s.clearing_house
  then (failwith "USER_NOT_FOUND": storage)
  else
    let {
      pool_id = pool_id;
      base_asset = base_asset;
    } = p in
    let user_deposited_cash: int = Big_map.find Tezos.sender s.clearing_house in
    if user_deposited_cash < int (base_asset)
    then (failwith "NOT_ENOUGH_CASH_DEPOSITED": storage)
    else
      let base_asset = base_asset * 100_000_000n in
      let pool_info: pool_storage = Big_map.find pool_id s.pool_ledger in
      let fees = (pool_info.fee_ratio * base_asset / 10_000n) in
      let spread_ratio = (pool_info.spread_ratio * base_asset / 10_000n) in
      let new_base_amount = pool_info.base_asset_amt + base_asset - fees - spread_ratio in
      let quote_asset_to_buyer = ((pool_info.base_asset_amt * pool_info.quote_asset_amt) / new_base_amount) - pool_info.quote_asset_amt in
      let new_quote_amount = pool_info.quote_asset_amt - abs(quote_asset_to_buyer) in
      let new_longs =
        match Map.find_opt Tezos.sender pool_info.longs with
        | None -> Map.add Tezos.sender (quote_asset_to_buyer) pool_info.longs
        | Some t -> Map.update Tezos.sender (Some (t + quote_asset_to_buyer)) pool_info.longs
      in
      let new_pool_storage : pool_storage = {
        fee_ratio = pool_info.fee_ratio;
        spread_ratio = pool_info.spread_ratio;
        quote_asset_amt = abs(new_quote_amount);
        base_asset_amt = abs(new_base_amount);
        longs = new_longs;
        shorts = pool_info.shorts;
        total_long = pool_info.total_long + quote_asset_to_buyer;
        total_short = pool_info.total_short;
      } in
      let new_pool_ledger = Big_map.update pool_id (Some (new_pool_storage)) s.pool_ledger in
      { 
        s with 
          pool_ledger = new_pool_ledger;
      }

let short(p, s: trade_params * storage): storage =
  if not Big_map.mem Tezos.sender s.clearing_house
  then (failwith "USER_NOT_FOUND": storage)
  else
    let {
      pool_id = pool_id;
      base_asset = base_asset;
    } = p in
    let user_deposited_cash: int = Big_map.find Tezos.sender s.clearing_house in
    if user_deposited_cash < int (base_asset)
    then (failwith "NOT_ENOUGH_CASH_DEPOSITED": storage)
    else
      let base_asset = base_asset * 100_000_000n in
      let pool_info: pool_storage = Big_map.find pool_id s.pool_ledger in
      let fees = (pool_info.fee_ratio * base_asset / 10_000n) in
      let spread_ratio = (pool_info.spread_ratio * base_asset / 10_000n) in
      let new_base_amount = pool_info.base_asset_amt - base_asset - fees - spread_ratio in
      let quote_asset_to_buyer = ((pool_info.base_asset_amt * pool_info.quote_asset_amt) / new_base_amount) - pool_info.quote_asset_amt in
      let new_quote_amount = pool_info.quote_asset_amt + abs(quote_asset_to_buyer) in
      let new_shorts =
        match Map.find_opt Tezos.sender pool_info.shorts with
        | None -> Map.add Tezos.sender (quote_asset_to_buyer) pool_info.shorts
        | Some t -> Map.update Tezos.sender (Some (t + quote_asset_to_buyer)) pool_info.shorts
      in
      let new_pool_storage : pool_storage = {
        fee_ratio = pool_info.fee_ratio;
        spread_ratio = pool_info.spread_ratio;
        quote_asset_amt = new_quote_amount;
        base_asset_amt = abs(new_base_amount);
        longs = pool_info.longs;
        shorts = new_shorts;
        total_long = pool_info.total_long;
        total_short = pool_info.total_short + quote_asset_to_buyer;
      } in
      let new_pool_ledger = Big_map.update pool_id (Some (new_pool_storage)) s.pool_ledger in
      { 
        s with 
          pool_ledger = new_pool_ledger;
      }

let close_long(p, s: close_params * storage): storage =
  let {
    pool_id = pool_id;
    quote_asset = quote_asset;
  } = p in
  let quote_asset = quote_asset * 100_000_000n in
  let pool_info: pool_storage = Big_map.find pool_id s.pool_ledger in
  let quote_amt = pool_info.quote_asset_amt in
  let base_amt = pool_info.base_asset_amt in
  let price = base_amt / quote_amt in
  let base_asset = price * quote_asset in
  let fees = (pool_info.fee_ratio * base_asset / 10_000n) in
  let spread_ratio = (pool_info.spread_ratio * base_asset / 10_000n) in
  let new_base_amount = pool_info.base_asset_amt - base_asset - fees - spread_ratio in
  let quote_asset_to_buyer = ((pool_info.base_asset_amt * pool_info.quote_asset_amt) / new_base_amount) - pool_info.quote_asset_amt in
  let new_quote_amount = pool_info.quote_asset_amt + abs(quote_asset_to_buyer) in
  let new_longs =
    match Map.find_opt Tezos.sender pool_info.longs with
    | None -> Map.add Tezos.sender (-quote_asset_to_buyer) pool_info.longs
    | Some t -> Map.update Tezos.sender (Some (t - quote_asset_to_buyer)) pool_info.longs
  in
  let new_pool_storage : pool_storage = {
    fee_ratio = pool_info.fee_ratio;
    spread_ratio = pool_info.spread_ratio;
    quote_asset_amt = new_quote_amount;
    base_asset_amt = abs(new_base_amount);
    longs = new_longs;
    shorts = pool_info.shorts;
    total_long = pool_info.total_long - quote_asset_to_buyer;
    total_short = pool_info.total_short;
  } in
  let new_pool_ledger = Big_map.update pool_id (Some (new_pool_storage)) s.pool_ledger in
  { 
    s with 
      pool_ledger = new_pool_ledger;
  }

let close_short(p, s: close_params * storage): storage =
  let {
    pool_id = pool_id;
    quote_asset = quote_asset;
  } = p in
  let quote_asset = quote_asset * 100_000_000n in
  let pool_info: pool_storage = Big_map.find pool_id s.pool_ledger in
  let quote_amt = pool_info.quote_asset_amt in
  let base_amt = pool_info.base_asset_amt in
  let price = base_amt / quote_amt in
  let base_asset = price * quote_asset in
  let fees = (pool_info.fee_ratio * base_asset / 10_000n) in
  let spread_ratio = (pool_info.spread_ratio * base_asset / 10_000n) in
  let new_base_amount = pool_info.base_asset_amt + base_asset - fees - spread_ratio in
  let quote_asset_to_buyer = ((pool_info.base_asset_amt * pool_info.quote_asset_amt) / new_base_amount) - pool_info.quote_asset_amt in
  let new_quote_amount = pool_info.quote_asset_amt - abs(quote_asset_to_buyer) in
  let new_shorts =
    match Map.find_opt Tezos.sender pool_info.shorts with
    | None -> Map.add Tezos.sender (-quote_asset_to_buyer) pool_info.shorts
    | Some t -> Map.update Tezos.sender (Some (t - quote_asset_to_buyer)) pool_info.shorts
  in
  let new_pool_storage : pool_storage = {
    fee_ratio = pool_info.fee_ratio;
    spread_ratio = pool_info.spread_ratio;
    quote_asset_amt = abs(new_quote_amount);
    base_asset_amt = abs(new_base_amount);
    longs = pool_info.longs;
    shorts = new_shorts;
    total_long = pool_info.total_long;
    total_short = pool_info.total_short - quote_asset_to_buyer;
  } in
  let new_pool_ledger = Big_map.update pool_id (Some (new_pool_storage)) s.pool_ledger in
  { 
    s with 
      pool_ledger = new_pool_ledger;
  }

let update_floor_price(p, s: update_floor_price_params * storage): storage =
  let {
    token_id = token_id;
    floor_price = floor_price;
  } = p in
  let pool_id = Big_map.find (token_id) s.token_ledger in
  let pool_info: pool_storage = Big_map.find pool_id s.pool_ledger in
  let market_price = pool_info.base_asset_amt / pool_info.quote_asset_amt in
  let price_diff = market_price - floor_price / 1tez in
  let total_long = pool_info.total_long in
  let total_short = pool_info.total_short in
  // // GET LIST OF SHORT / LONGS
  let dec_long = fun (c, j : (address, int) big_map * (address * int)) -> Big_map.update (j.0) (Some ((Big_map.find (j.0) c) - (abs(price_diff) * (j.1 / total_long)))) c in
  let inc_long = fun (c, j : (address, int) big_map * (address * int)) -> Big_map.update (j.0) (Some ((Big_map.find (j.0) c) + (abs(price_diff) * (j.1 / total_long)))) c in
  let dec_short = fun (c, j : (address, int) big_map * (address * int)) -> Big_map.update (j.0) (Some ((Big_map.find (j.0) c) - (abs(price_diff) * (j.1 / total_short)))) c in
  let inc_short = fun (c, j : (address, int) big_map * (address * int)) -> Big_map.update (j.0) (Some ((Big_map.find (j.0) c) + (abs(price_diff) * (j.1 / total_short)))) c in
  if price_diff >= 0
  then
    let new_c = Map.fold dec_short pool_info.shorts s.clearing_house in
    let new_c = Map.fold inc_long pool_info.longs new_c in
    let new_pool_storage : pool_storage = {
      fee_ratio = pool_info.fee_ratio;
      spread_ratio = pool_info.spread_ratio;
      quote_asset_amt = pool_info.quote_asset_amt;
      base_asset_amt = pool_info.base_asset_amt;
      longs = pool_info.longs;
      shorts = pool_info.shorts;
      total_long = pool_info.total_long;
      total_short = pool_info.total_short;
    } in
    let new_pool_ledger = Big_map.update pool_id (Some (new_pool_storage)) s.pool_ledger in
    {
      s with
        pool_ledger = new_pool_ledger;
        clearing_house = new_c;
    }
  else
    let new_c = Map.fold inc_short pool_info.shorts s.clearing_house in
    let new_c = Map.fold dec_long pool_info.longs new_c in
    let new_pool_storage : pool_storage = {
      fee_ratio = pool_info.fee_ratio;
      spread_ratio = pool_info.spread_ratio;
      quote_asset_amt = pool_info.quote_asset_amt;
      base_asset_amt = pool_info.base_asset_amt;
      longs = pool_info.longs;
      shorts = pool_info.shorts;
      total_long = pool_info.total_long;
      total_short = pool_info.total_short;
    } in
    let new_pool_ledger = Big_map.update pool_id (Some (new_pool_storage)) s.pool_ledger in
    {
      s with
        pool_ledger = new_pool_ledger;
        clearing_house = new_c;
    }
