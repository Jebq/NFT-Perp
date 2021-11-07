let sell (p, s: sell_params * storage): operation list * storage =
    let { destination = destination; amount = amt; token_id = token_id; price = price} = p in
    let new_ledger: ledger =
        match Big_map.find_opt (Tezos.sender, token_id) s.ledger with
        | None -> Big_map.add (Tezos.sender, token_id) amt s.ledger
        | Some b -> Big_map.update (Tezos.sender, token_id) (Some (b + amt)) s.ledger
    in
        (* Stores the metadata *)
    let new_entry = {
        token_id = token_id;
        token_owner = Tezos.sender;
        token_price = price;
        token_floor_price =  price;
        } in
    (* Call Transfer FA2 Contract *)
    let dest: fa2_contract_transfer_type list contract option = Tezos.get_entrypoint_opt "%transfer" destination in
    let destInterface : fa2_contract_transfer_type list contract = 
      match (dest) with
        | Some ci -> ci
        | None -> (failwith "Contract not found or no entrypoint %transfer." : fa2_contract_transfer_type list contract) in
    let sell_params = ([{
        from_ = Tezos.sender;
        txs = [{to_ = Tezos.self_address; token_id = token_id; amount=amt}]
    }]: fa2_contract_transfer_type list) in
    let op = Tezos.transaction sell_params 0mutez destInterface in
    ([op], 
    { 
        s with 
            ledger = new_ledger; 
            token_metadata = Big_map.add token_id new_entry s.token_metadata;
            total_supply = if token_id = 0n then s.total_supply + amt else s.total_supply 
    })