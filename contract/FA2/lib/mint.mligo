let mint (p, s: mint_params * storage): storage =
    let { recipient = recipient; link_to_metadata = link_to_metadata; amount = amt; token_id = token_id } = p in
    let new_entry = { token_id = token_id; token_info = Map.literal [("", link_to_metadata)] } in
    let new_ledger: ledger =
        match Big_map.find_opt (recipient, token_id) s.ledger with
        | None -> Big_map.add (recipient, token_id) amt s.ledger
        | Some b -> Big_map.update (recipient, token_id) (Some (b + amt)) s.ledger
    in
    { 
        s with 
            ledger = new_ledger; 
            total_supply = if token_id = 0n then s.total_supply + amt else s.total_supply;
            token_metadata = Big_map.add token_id new_entry s.token_metadata;
    }