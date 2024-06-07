dashboard "Pipelines_Failed" {

  tags = {
    service = "Pipes"
  }

  container {
    text {
      value = replace(
        replace(
          "${local.menu}",
          "__HOST__",
          "${local.host}"
        ),
        "[Pipelines_Failed](${local.host}/pipes.dashboard.Pipelines_Failed)",
        "Pipelines_Failed"
      )
    }
  }  

  table {
    title = "Pipelines_Failed"
    sql = <<EOQ
      select
        title,
        workspace_handle,
        identity_handle,
        last_process_id,
        last_process->>'created_at' as last_process_created_at,
        identity_type,
        id
      from
        pipes.pipes_workspace_pipeline
      where
        last_process->>'state' = 'failed'
    EOQ
    column "title" {
      href = "https://pipes.turbot.com/{{.'identity_type'}}/{{.'identity_handle'}}/workspace/{{.'workspace_handle'}}/activity/process/{{.'last_process_id'}}"
    }
  }


}