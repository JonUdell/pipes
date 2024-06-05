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
    width = 6
    sql = <<EOQ
      with data as (
          select
              suppress_and_count_repeats(
                  'pipes',
                  'pipes_connection',
                  'plugin',
                  'identity_handle, handle',
                  array['identity_handle', 'handle', 'created_by']
              ) as json_data
      )
      select
          json_data->>'display_partition_column' as plugin,
          concat(
            json_data->'additional_columns'->>0,
            '/',
            json_data->'additional_columns'->>1
          ) as org_workspace,
          json_data->'additional_columns'->2->>'handle' as conn_created_by
      from data
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

