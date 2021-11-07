let update_operators (operators_list, s: (update_operators_param list) * storage): storage =
    List.fold
        (
            fun ((s, operator_param): storage * update_operators_param) ->
                match operator_param with
                | Add_operator p ->
                    let { owner = owner; operator = operator; token_id = token_id } = p in
                    if Tezos.sender <> owner
                    then (failwith "FA2_NOT_OWNER": storage)
                    else
                        { s with operators = Big_map.add ((owner, operator), token_id) unit s.operators }
                | Remove_operator p->
                    let { owner = owner; operator = operator; token_id = token_id } = p in
                    if Tezos.sender <> owner
                    then (failwith "FA2_NOT_OWNER": storage)
                    else
                        { s with operators = Big_map.remove ((owner, operator), token_id) s.operators }
        )
        operators_list
        s