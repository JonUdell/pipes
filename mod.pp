mod "pipes" {
  title = "pipes"
}

locals {
  //host = "https://pipes.turbot.com/org/turbot-ops/workspace/pipes/dashboard"
  host = "http://localhost:9033"
  
  menu = <<EOT
[My_Orgs](__HOST__/pipes.dashboard.My_Orgs)
•
[My_Workspaces](__HOST__/pipes.dashboard.My_Workspaces)
EOT
}