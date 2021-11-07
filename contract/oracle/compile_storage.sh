docker run --rm -v "$PWD":"$PWD" -w "$PWD" ligolang/ligo:0.27.0 compile-storage main.mligo main '{
  price = (Big_map.empty: (token_id, tez) big_map);
  source = ("tz1MRB76Lq8xQhQ4bsZGvYpHGT4SqUYA6yop": address);
  admin = ("tz1SjK9LU9YTdEXeMGVcMCpU2bTj2TrsZxiD": address);
  }' > michelson/oracle_storage.tz