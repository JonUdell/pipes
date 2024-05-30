dashboard "My_Audits" {

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
        "[My_Audits](${local.host}/pipes.dashboard.My_Audits)",
        "My_Audits"
      )
    }
  }  


  table {
    title = "My audits"
    sql = <<EOQ
      with handle as (
        select handle from pipes_user
      )
      select
        *
      from
        pipes_audit_log a
      join 
        handle h 
      on h.handle = a.identity_handle
    EOQ
  }


}