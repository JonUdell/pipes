dashboard "Pipelines" {

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
        "[Pipelines](${local.host}/pipes.dashboard.Pipelines)",
        "Pipelines"
      )
    }
  }  

  container {

    card "Completed" {
      width = 2
      sql = "select count(*) as Completed from pipes.pipes_workspace_pipeline where last_process->>'state' = 'completed'"
    }

    card "Failed" {
      width = 2
      sql = "select count(*) as Failed from pipes.pipes_workspace_pipeline where last_process->>'state' = 'failed'"
    }

    card "Newest" {
      width = 3
      sql = <<EOQ
        select to_char(max(last_process->>'created_at')::timestamptz,'YYYY-MM-DD:H24') as newest
        from pipes.pipes_workspace_pipeline
      EOQ
    }

    card "Oldest" {
      width = 3
      sql = <<EOQ
        select to_char(min(last_process->>'created_at')::timestamptz,'YYYY-MM-DD:H24') as oldest
        from pipes.pipes_workspace_pipeline
      EOQ
    }



  
  }

  table {
    title = "Pipelines"
    sql = <<EOQ
      select
        pipeline,
        identity_handle || '/' ||  workspace_handle as org_workspace,
        title,
        last_process->>'state' as state,
        last_process->>'updated_at' as updated_at,
        frequency,
        id,
        identity_handle,
        workspace_handle,
        last_process
      from
        pipes.pipes_workspace_pipeline
      order by state desc
      limit 100
    EOQ
    column "pipeline" {
      href = "https://pipes.turbot.com/org/{{.'identity_handle'}}/workspace/{{.'workspace_handle'}}/pipeline/{{.'id'}}"
    }
  }


}