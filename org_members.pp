dashboard "My_Org_Members" {

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
        "[My_Org_Members](${local.host}/pipes.dashboard.My_Org_Members)",
        "My_Org_Members"
      )
    }
  }  


  table {
    width = 4
    title = "My org members"

    sql = <<EOQ
    with cte as (
        select
            org_handle,
            user_handle,
            status,
            row_number() over (partition by org_handle order by user_handle) as rn,
            dense_rank() over (order by org_handle) as org_rank
        from
            pipes.pipes_organization_member
    )
    select
        case
            when rn = 1 then org_handle
            else ''
        end as org_handle,
        user_handle,
        status
    from
        cte
    order by
        org_rank,
        rn;
   EOQ
  }


}