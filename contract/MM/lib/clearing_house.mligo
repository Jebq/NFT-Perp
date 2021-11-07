let default_(s: storage): storage =
  let amt = Tezos.amount in
  let new_clearing_house =
    match Big_map.find_opt Tezos.sender s.clearing_house with
    | None -> Big_map.add Tezos.sender (int (amt / 1tez)) s.clearing_house
    | Some t -> Big_map.update Tezos.sender (Some (t + int (amt / 1tez))) s.clearing_house
  in
  {
    s with
      clearing_house = new_clearing_house;
  }

let unlock_funds(p, s: unlock_funds_params * storage): operation list * storage =
  if not Big_map.mem Tezos.sender s.clearing_house
  then (failwith "USER_NOT_FOUND": operation list * storage)
  else
    let {amt = amt} = p in
    let user_deposited_cash: int = Big_map.find Tezos.sender s.clearing_house in
    let new_deposit = user_deposited_cash - amt / 1tez in
    if new_deposit < 0
    then (failwith "NOT_ENOUGH_CASH_DEPOSITED": operation list * storage)
    else
      let new_clearing_house = Big_map.update Tezos.sender (Some (new_deposit)) s.clearing_house in
      let op_xtz = xtz_transfer Tezos.sender (amt) in
      ([op_xtz],
      {
        s with
          clearing_house = new_clearing_house;
      })