dashboard "My_Orgs" {

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
        "[My_Orgs](${local.host}/pipes.dashboard.My_Orgs)",
        "My_Orgs"
      )
    }
  }  


  table {
    title = "My orgs"
    sql = <<EOQ
      select 
        handle,
        display_name,
        id,
        created_at,
        updated_at
      from pipes_organization
      order by handle
    EOQ
  }


}