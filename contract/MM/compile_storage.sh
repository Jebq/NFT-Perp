docker run --rm -v "$PWD":"$PWD" -w "$PWD" ligolang/ligo:0.27.0 compile-storage main.mligo main '{
  token_ledger = (Big_map.empty: (token_id, pool_id) big_map);
  clearing_house = (Big_map.empty: (address, int) big_map);
  pool_ledger = (Big_map.empty: (pool_id, pool_storage) big_map);
  admin = ("tz1SjK9LU9YTdEXeMGVcMCpU2bTj2TrsZxiD": address);
}' > michelson/mm_storage.tz