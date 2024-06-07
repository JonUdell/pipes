dashboard "Queries" {

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
        "[Queries](${local.host}/pipes.dashboard.Queries)",
        "Queries"
      )
    }
  }  

  table {
    title = "Queries"
    sql = <<EOQ
      with handle as (
        select handle from pipes.pipes_user
      )
      select
        actor_handle,
        workspace_handle,
        substring(created_at from 1 for 19) as created_at,
        duration,
        substring(query from 1 for 400) as query
      from
        pipes.pipes_workspace_db_log w
      join 
        handle h 
      on 
        h.handle = w.actor_handle
      where
        query !~ '-- ping|introspection|SHOW|SET|pg_tables|steampipe_internal|information_schema'
      order by
        created_at desc
      limit 20
    EOQ
    column "query" {
      wrap = "all"
    }
  }


}