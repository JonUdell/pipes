dashboard "My_Workspaces" {

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
        "[My_Workspaces](${local.host}/pipes.dashboard.My_Workspaces)",
        "My_Workspaces"
      )
    }
  }  


  table {
    title = "My workspaces"
    sql = <<EOQ
      with org_data as (
          select id as org_id, handle as org_handle, created_by_id
          from pipes.pipes_organization
      )
      select 
        org_handle,
        w.handle as w_handle,
        w.id as w_id,
        display_name,
        status,
        database_name,
        state,
        created_by->>'display_name' as w_created_by,
        cli_version,
        api_version
      from org_data o 
      left join pipes.pipes_user p on o.created_by_id = p.id
      join pipes.pipes_workspace w on o.org_id = w.identity_id
      order by org_handle, w.handle
      EOQ
    column "w_id" {
      href = "${local.host}/pipes.dashboard.Workspace_Detail?input.workspace_ids={{.'w_id'}}"      
    }  

  }


}