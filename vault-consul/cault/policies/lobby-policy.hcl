# List existing policies
path "sys/policy"
{
  capabilities = ["read"]
}

# List, create, and update key/value secrets
path "secret/*"
{
  capabilities = ["create", "read", "update", "list"]
}
