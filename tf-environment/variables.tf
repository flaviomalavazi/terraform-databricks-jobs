# Step 1: Initializing configs and variables 
variable "tags" {
  type        = map(any)
  description = "(Optional) List of tags to be propagated accross all assets in this demo"
}

variable "databricks_auth_token" {
  type        = string
  description = "(Required) Databricks Auth token"
}

variable "databricks_repos_notebook_path" {
  type        = string
  description = "(Required) Databricks repos path for notebooks"
  default     = "/Repos/Production/terraform-databricks-jobs"
}

variable "databricks_workspace_url" {
  type        = string
  description = "(Required) Databricks Workspace URL"
}

resource "random_string" "naming" {
  special = false
  upper   = false
  length  = 6
}

locals {
  prefix = "demo-${random_string.naming.result}"
  tags   = var.tags
}
