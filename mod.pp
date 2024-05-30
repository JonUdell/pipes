mod "pipes" {
  title = "pipes"
}

locals {
  host = "https://pipes.turbot.com/org/turbot-ops/workspace/stats/dashboard"
  //host = "http://localhost:9033"
  
  menu = <<EOT
[My_Audits](__HOST__/pipes.dashboard.My_Audits)
•
[My_Connections](__HOST__/pipes.dashboard.My_Connections)
•
[My_Orgs](__HOST__/pipes.dashboard.My_Orgs)
•
[My_Org_Members](__HOST__/pipes.dashboard.My_Org_Members)
•
[My_Workspaces](__HOST__/pipes.dashboard.My_Workspaces)
•
[Workspaces_Detail](__HOST__/pipes.dashboard.Workspace_Detail)
EOT
}