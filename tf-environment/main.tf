# Getting the latest LTS DBR version 
data "databricks_spark_version" "latest_lts" {
  long_term_support = true
  ml                = false
  photon            = true
}

data "databricks_node_type" "smallest" {
  local_disk            = true
  photon_driver_capable = true
  photon_worker_capable = true
}

resource "databricks_job" "job_do_chan" {
  name = "__Job with multiple tasks defined using terraform"

  job_cluster {
    job_cluster_key = "job_cluster"
    new_cluster {
      num_workers   = 2
      spark_version = data.databricks_spark_version.latest_lts.id
      node_type_id  = data.databricks_node_type.smallest.id
      custom_tags   = local.tags
    }
  }

  task {
    task_key = "first_task"

    job_cluster_key = "job_cluster"

    notebook_task {
      notebook_path = "${var.databricks_repos_notebook_path}/notebooks/First_task"
    }
  }

  task {
    task_key = "second_task"
    //this task will only run after the first task
    depends_on {
      task_key = "first_task"
    }

    job_cluster_key = "job_cluster"

    notebook_task {
      notebook_path = "${var.databricks_repos_notebook_path}/notebooks/Second_task"
    }

  }

  tags = local.tags

}

# resource "databricks_permissions" "job_usage" {
#   job_id = resource.databricks_job.this.id

#   access_control {
#     group_name       = "users"
#     permission_level = "CAN_VIEW"
#   }

#   access_control {
#     group_name       = databricks_group.auto.display_name
#     permission_level = "CAN_MANAGE_RUN"
#   }

#   access_control {
#     group_name       = databricks_group.eng.display_name
#     permission_level = "CAN_MANAGE"
#   }

#   access_control {
#     service_principal_name = databricks_service_principal.aws_principal.application_id
#     permission_level       = "IS_OWNER"
#   }
# }
