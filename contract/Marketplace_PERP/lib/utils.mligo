[@inline]
let xtz_transfer (to_ : address) (amount_ : tez) : operation =
    let to_contract : unit contract =
        match (Tezos.get_contract_opt to_ : unit contract option) with
        | None -> (failwith "INVALID_ADDRESS" : unit contract)
        | Some c -> c in
    Tezos.transaction () amount_ to_contract