# Read and list auth methods broadly across Vault
path "auth/*"
{
  capabilities = ["read", "list"]
}

# Read auth methods
path "sys/auth/*"
{
  capabilities = ["read"]
}

# List existing policies
path "sys/policy"
{
  capabilities = ["read"]
}

# Read and list ACL policies
path "sys/policy/*"
{
  capabilities = ["read", "list"]
}

# List, create, update, and delete key/value secrets
path "secret/*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}
