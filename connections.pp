dashboard "My_Connections" {

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
        "[My_Connections](${local.host}/pipes.dashboard.My_Connections)",
        "My_Connections"
      )
    }
  }  


  table {
    title = "My Connections"
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

