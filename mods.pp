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
      select
        identity_handle || '/' ||  workspace_handle as org_workspace,
        alias || ' ' || installed_version as mod,
        path,
        "constraint",
        state
      from
        pipes.pipes_workspace_mod
      order by
        identity_handle, workspace_handle
      EOQ
  }


}