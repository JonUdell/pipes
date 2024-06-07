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
        identity_handle,
        action_type,
        actor_display_name,
        to_char(created_at, 'YYYY-MM-DD:HH:mm') as created_at,
        target_handle,
        jsonb_pretty(data) as data
      from
        pipes.pipes_audit_log a
      join 
        handle h 
      on h.handle = a.identity_handle
      order by created_at desc
    EOQ
  }


}