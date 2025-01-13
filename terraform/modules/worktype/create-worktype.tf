resource "genesyscloud_task_management_worktype" "hubspot_worktype" {
  name        = "HubSpot Worktype"
  description        = "Description for my worktype"
  default_workbin_id = var.workbin_id
  schema_id          = var.schema_id
  schema_version     = 4
  division_id        = var.division_id
}