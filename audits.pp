dashboard "Audits" {

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
        "[Audits](${local.host}/pipes.dashboard.Audits)",
        "Audits"
      )
    }
  }  


  table {
    title = "audits"
    sql = <<EOQ
      with handle as (
        select handle from pipes.pipes_user
      )
      select
        *
      from
        pipes.pipes_audit_log a
      join 
        handle h 
      on h.handle = a.identity_handle
    EOQ
  }


}