dashboard "MyWorkspaces" {

  tags = {
    service = "Pipes"
  }

  table {
    title = "My workspaces"
    sql = <<EOQ
      with org_data as (
          select id as org_id, handle as org_handle, created_by_id
          from pipes_organization
      )
      select 
        org_handle,
        w.handle as w_handle,
        display_name,
        status,
        database_name,
        state,
        created_by->>'display_name' as w_created_by,
        cli_version,
        api_version
      from org_data o 
      left join pipes_user p on o.created_by_id = p.id
      join pipes_workspace w on o.org_id = w.identity_id
      order by org_handle, w.handle
      EOQ
  }

}