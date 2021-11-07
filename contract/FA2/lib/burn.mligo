let burn (p, s: burn_params * storage): storage =
    if Tezos.sender <> s.admin && Tezos.sender <> Tezos.self_address && Tezos.sender <> p.owner
    then (failwith "NOT_AN_ADMIN": storage)
    else
        let new_ledger: ledger =
            match Big_map.find_opt (p.owner, p.token_id) s.ledger with
            | None -> s.ledger
            | Some b -> 
                if p.amount > b
                then (failwith "INSUFFICIENT_TOKENS_TO_BURN": ledger)
                else Big_map.update (p.owner, p.token_id) (Some (abs(b - p.amount))) s.ledger
        in { 
                s with 
                    ledger = new_ledger; 
                    total_supply = if p.token_id = 0n then abs (s.total_supply - p.amount) else s.total_supply 
            }