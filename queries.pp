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
        pg_typeof(created_at),
        --to_char(created_at, 'YYYY-MM-DD:H24') as created_at,
        duration,
        substring(query from 1 for 400) as query
      from
        pipes.pipes_workspace_db_log w
      join 
        handle h 
      on 
        h.handle = w.actor_handle
      where
        query !~ '-- ping'
        and query !~ 'introspection'
      order by
        created_at desc
      limit 100
    EOQ
    column "query" {
      wrap = "all"
    }
  }


}