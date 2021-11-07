docker run --rm -v "$PWD":"$PWD" -w "$PWD" ligolang/ligo:0.27.0 compile-storage main.mligo main '{
  ledger = (Big_map.empty: ((address * token_id), nat) big_map);
  operators = (Big_map.empty: (((address * address) * token_id), unit) big_map);
  metadata = Big_map.literal [
  ("", Bytes.pack("tezos-storage:contents"));
  ("contents", ("7b2276657273696f6e223a2276302e3031222c226e616d65223a2250455250735f464132227d": bytes))
  ];
  token_metadata = (Big_map.empty: (token_id, token_metadata_val) big_map);
  admin = ("tz1SjK9LU9YTdEXeMGVcMCpU2bTj2TrsZxiD": address);
  total_supply = 0n;
}' > michelson/fa2_storage.tz