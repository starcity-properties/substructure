# List existing policies
path "sys/policy"
{
  capabilities = ["read"]
}

# Read and list key/value secrets
path "secret/*"
{
  capabilities = ["read", "list"]
}
