provider "databricks" {
  host  = var.databricks_workspace_url
  token = var.databricks_auth_token
}
