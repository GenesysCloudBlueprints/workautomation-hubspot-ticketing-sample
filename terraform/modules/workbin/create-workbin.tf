resource "genesyscloud_task_management_workbin" "hubspot_workbin" {
  name        = "HubSpot Workbin"
  division_id = var.division_id
}