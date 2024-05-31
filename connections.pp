dashboard "Connections" {

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
        "[Connections](${local.host}/pipes.dashboard.Connections)",
        "Connections"
      )
    }
  }  

  table {
    title = "Connections"
    width = 4
    sql = <<EOQ
      with cte as (
          select
              plugin,
              handle || '/' || identity_handle as org_workspace,
              row_number() over (partition by plugin order by handle, identity_handle) as row_num,
              count(*) over (partition by plugin) as plugin_count,
              dense_rank() over (order by plugin) as dense_rank
          from
              pipes_connection
      )
      select
          case
              when row_num = 1 then plugin || ' (' || plugin_count || ')'
              else ''
          end as plugin,
          org_workspace
      FROM
          cte
      ORDER BY
          dense_rank,
          row_num;
    EOQ
  }

  table {
    title = "By plugin"
    width = 2
    sql = <<EOQ
      select
          plugin,
          count(*)
      from
          pipes_connection
      group by
          plugin
      order by
          plugin
    EOQ
  }

table {
    title = "By count"
    width = 2
    sql = <<EOQ
      select
          plugin,
          count(*)
      from
          pipes_connection
      group by
          plugin
      order by
          count desc
    EOQ
}
    


}

