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
    sql = <<EOQ
      select
        plugin,
        handle,
        identity_handle
      from
        pipes.pipes_connection
      order by
        plugin, identity_handle
    EOQ
  }

}

