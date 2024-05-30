dashboard "Workspace_Detail" {

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
      "[Workspace_Detail](${local.host}/pipes.dashboard.Workspace_Detail)",
      "Workspace_Detail"
    )
  }

  input "workspace_ids" {
    width = 4
    sql = <<EOQ
      select
        handle || '/' || identity_handle as label,
        id as value
      from
        pipes.pipes_workspace
      order by
        identity_handle, handle
    EOQ
  }
}  

table {
  width = 4
  type = "line"
  args = [self.input.workspace_ids.value]
  sql = <<EOQ
    select
      *
    from
      pipes.pipes_workspace
    where
      id = $1
    EOQ
  }
}