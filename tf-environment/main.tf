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

resource "databricks_job" "this" {
  name = "__Job with multiple tasks defined using terraform"

  job_cluster {
    job_cluster_key = "job_cluster"
    new_cluster {
      num_workers   = 1
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
