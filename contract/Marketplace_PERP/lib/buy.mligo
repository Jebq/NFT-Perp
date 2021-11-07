let buy (p, s: buy_params * storage): operation list * storage =
    if not Big_map.mem p.token_id s.token_metadata
    then ([]: operation list), (failwith "FA2_TOKEN_UNDEFINED": storage)
    else
        let { destination = destination; amount = amt; token_id = token_id} = p in
        let token_metadata: token_metadata_val  =
          match Big_map.find_opt token_id s.token_metadata with
          | None -> (failwith "FA2_TOKEN_UNDEFINED": token_metadata_val)
          | Some m -> m in
        if Tezos.amount < (amt * token_metadata.token_price) then
          (failwith "This contract does not accept tokens." : operation list * storage)
        else (
          let seller_address: address = token_metadata.token_owner in
          let seller_balance: nat =
              match Big_map.find_opt (seller_address, token_id) s.ledger with
              | None -> 0n
              | Some b -> b in
          let new_ledger: ledger = Big_map.update (seller_address, token_id) (Some (abs (seller_balance - amt))) s.ledger in
          let new_ledger: ledger =
              match Big_map.find_opt (Tezos.sender, token_id) s.ledger with
              | None -> Big_map.add (Tezos.sender, token_id) amt s.ledger
              | Some b -> Big_map.update (Tezos.sender, token_id) (Some (b + amt)) new_ledger
          in
          (* Stores the metadata *)
          let new_entry = {
              token_id = token_id;
              token_owner = Tezos.sender;
              token_price = token_metadata.token_price;
              token_floor_price =  token_metadata.token_price;
              } in
          (* Call Transfer FA2 Contract *)
            let dest: fa2_contract_transfer_type list contract option = Tezos.get_entrypoint_opt "%transfer" destination in
            let destInterface : fa2_contract_transfer_type list contract = 
            match (dest) with
                | Some ci -> ci
                | None -> (failwith "Contract not found or no entrypoint %transfer." : fa2_contract_transfer_type list contract) in
          let buy_params : fa2_contract_transfer_type list = [{
              from_ = Tezos.self_address;
              txs = [{to_ = Tezos.sender; token_id = token_id; amount = amt}]
          }] in
          (* ADD TEZOS TRANSFER TO PREVIOUS OWNER *)
          let op_xtz = xtz_transfer seller_address (token_metadata.token_price * amt) in
          let op = Tezos.transaction buy_params 0mutez destInterface in
          ([op_xtz; op], 
          { 
              s with 
                  ledger = new_ledger; 
                  token_metadata = Big_map.add token_id new_entry s.token_metadata;
                  total_supply = if token_id = 0n then s.total_supply + amt else s.total_supply 
          }))