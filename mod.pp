mod "pipes" {
  title = "pipes"
}

locals {
  //host = "https://pipes.turbot.com/user/judell/workspace/personal/dashboard"
  host = "http://localhost:9033"
  
  menu = <<EOT
[Audits](__HOST__/pipes.dashboard.Audits)
•
[Connections](__HOST__/pipes.dashboard.Connections)
•
[Orgs](__HOST__/pipes.dashboard.Orgs)
•
[Org_Members](__HOST__/pipes.dashboard.Org_Members)
•
[Pipelines](__HOST__/pipes.dashboard.Pipelines)
•
[Queries](__HOST__/pipes.dashboard.Queries)
•
[Workspaces](__HOST__/pipes.dashboard.Workspaces)
•
[Workspace_Detail](__HOST__/pipes.dashboard.Workspace_Detail)
EOT
}