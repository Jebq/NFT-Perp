let lock (p, s: lock_params * storage): operation list * storage =
    let { destination = destination; amount = amt; token_id = token_id; floor_price = floor_price} = p in
    let new_ledger: ledger =
        match Big_map.find_opt (Tezos.sender, token_id) s.ledger with
        | None -> Big_map.add (Tezos.sender, token_id) amt s.ledger
        | Some b -> Big_map.update (Tezos.sender, token_id) (Some (b + amt)) s.ledger
    in

    (* MINT a PERP token *)
    let new_perp_entry = {
        token_id = token_id;
        token_owner = Tezos.sender;
        } in
    let new_perp_ledger: ledger =
            match Big_map.find_opt (Tezos.sender, token_id) s.perp_ledger with
            | None -> Big_map.add (Tezos.sender, token_id) amt s.perp_ledger
            | Some b -> Big_map.update (Tezos.sender, token_id) (Some (b + amt)) s.perp_ledger in
    let new_perp_supply: perp_total_supply =
            match Big_map.find_opt (token_id) s.perp_total_supply with
            | None -> Big_map.add (token_id) amt s.perp_total_supply
            | Some b -> Big_map.update (token_id) (Some (b + amt)) s.perp_total_supply in
    (* Call Transfer FA2 Contract *)
    let dest: fa2_contract_transfer_type list contract option = Tezos.get_entrypoint_opt "%transfer" destination in
    let destInterface : fa2_contract_transfer_type list contract = 
    match (dest) with
        | Some ci -> ci
        | None -> (failwith "Contract not found or no entrypoint %transfer." : fa2_contract_transfer_type list contract) in
    let lock_params = ([{
        from_ = Tezos.sender;
        txs = [{to_ = Tezos.self_address; token_id = token_id; amount=amt}]
    }]: fa2_contract_transfer_type list) in
    let op = Tezos.transaction lock_params 0mutez destInterface in

    if not Big_map.mem p.token_id s.token_metadata
    then 
        (* Stores the metadata *)
        let new_token_entry = {
            token_id = token_id;
            token_owner = Tezos.sender;
            token_price = floor_price;
            token_floor_price =  floor_price
            } in
        ([op], 
        { 
            s with 
                ledger = new_ledger;
                perp_ledger = new_perp_ledger;
                perp_metadata = Big_map.add token_id new_perp_entry s.perp_metadata;
                token_metadata =  Big_map.add token_id new_token_entry s.token_metadata;
                total_supply = if token_id = 0n then s.total_supply + amt else s.total_supply;
                perp_total_supply = new_perp_supply;
        })
    else
        (* Stores the metadata *)
        let prev_token_entry = Big_map.find (p.token_id) s.token_metadata in
        let new_token_entry = {
            token_id = token_id;
            token_owner = Tezos.sender;
            token_price = prev_token_entry.token_price;
            token_floor_price =  floor_price
        } in
        ([op], 
        { 
            s with 
                ledger = new_ledger;
                perp_ledger = new_perp_ledger;
                perp_metadata = Big_map.add token_id new_perp_entry s.perp_metadata;
                token_metadata =  Big_map.update token_id (Some (new_token_entry)) s.token_metadata;
                total_supply = if token_id = 0n then s.total_supply + amt else s.total_supply;
                perp_total_supply = new_perp_supply;
        })