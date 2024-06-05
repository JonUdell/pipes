dashboard "Org_Members" {

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
        "[Org_Members](${local.host}/pipes.dashboard.Org_Members)",
        "Org_Members"
      )
    }
  }  

  table {
    width = 6
    title = "Org members"
    sql = <<EOQ
      with data as (
        select
          suppress_and_count_repeats (
            'pipes',
            'pipes_organization_member',
            'org_handle',
            'user_handle, user_id, status',
            array['user_handle', 'user_id', 'status']
          ) as json_data
      )
      select
        json_data ->> 'display_partition_column' as org_handle,
        (json_data -> 'additional_columns' ->> 0) as user_handle,
        (json_data -> 'additional_columns' ->> 1) as user_id,
        (json_data -> 'additional_columns' ->> 2) as status
      from
        data
   EOQ
  }


}