
type update_floor_price_params = 
[@layout:comb]
{
  token_id      : nat;
  floor_price   : tez;
}

let set_price(p, s: set_price_params * storage): operation list * storage =
  if Tezos.sender <> s.source
  then ([]: operation list), (failwith "UNAUTHORIZED": storage)
  else
    let {
      token_id = token_id;
      floor_price = floor_price;
      contract_address = contract_address;
    } = p in
    let new_price =
      match Big_map.find_opt (token_id) s.price with
      | None -> Big_map.add (token_id) floor_price s.price
      | Some _p -> Big_map.update (token_id) (Some (floor_price)) s.price
    in
    let update_fp_params: update_floor_price_params = {
      token_id = token_id;
      floor_price = floor_price;
    } in
    let dest: update_floor_price_params contract option = Tezos.get_entrypoint_opt "%update_floor_price" contract_address in
    let destInterface : update_floor_price_params contract = 
      match (dest) with
        | Some ci -> ci
        | None -> (failwith "Contract not found." : update_floor_price_params contract) in
      let op = Tezos.transaction update_fp_params 0mutez destInterface in
    ([op],
    {
      s with price = new_price;
    })

let set_source(p, s: address * storage): storage =
  if Tezos.sender <> s.admin
  then (failwith "UNAUTHORIZED": storage)
  else
    {
      s with source = p
    }
