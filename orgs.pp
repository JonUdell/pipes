dashboard "Orgs" {

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
        "[Orgs](${local.host}/pipes.dashboard.Orgs)",
        "Orgs"
      )
    }
  }  


  table {
    title = "Orgs"
    sql = <<EOQ
      select 
        handle,
        display_name,
        id,
        created_at,
        updated_at
      from pipes.pipes_organization
      order by handle
    EOQ
  }


}