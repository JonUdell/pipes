dashboard "Mods" {

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
        "[Mods](${local.host}/pipes.dashboard.Mods)",
        "Mods"
      )
    }
  }  

  container {
  
  }

  table {
    title = "Mods"
    sql = <<EOQ
      with data as (
        select * from suppress_and_count_repeats (
            'pipes',
            'pipes_workspace_mod',
            'identity_handle',
            'identity_handle, workspace_handle',
            array['workspace_handle', 'alias', 'installed_version', 'state', 'updated_at', 'created_by']
          ) as json_data
      )
      select
        json_data->>'display_partition_column' as org,
        json_data->'additional_columns'->>0 as workspace,
        json_data->'additional_columns'->>1 as alias,
        json_data->'additional_columns'->>2 as installed_version,
        json_data->'additional_columns'->>3 as state,
        json_data->'additional_columns'->>4 as updated_at,
        json_data->'additional_columns'->5->>'display_name' as created_by
      from
        data
      EOQ
  }


}