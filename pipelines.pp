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
        pipes_workspace_pipeline
      order by state desc
      limit 50
    EOQ
    column "pipeline" {
      href = "https://pipes.turbot.com/org/{{.'identity_handle'}}/workspace/{{.'workspace_handle'}}/pipeline/{{.'id'}}"
    }
  }


}