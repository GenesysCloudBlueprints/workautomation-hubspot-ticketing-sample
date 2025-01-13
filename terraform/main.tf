data "genesyscloud_user" "user" {
  email = var.email
}

// Create a Data Action integration
module "data_action" {
  source                          = "git::https://github.com/GenesysCloudDevOps/public-api-data-actions-integration-module?ref=main"
  integration_name                = "HubSpot Interaction"
  integration_creds_client_id     = var.client_id
  integration_creds_client_secret = var.client_secret
}

// Add DataAction for creating HubSpot tickets
module "create-hubspot-ticket" {
  source             = "./modules/actions/create-hubspot-ticket"
  action_name        = "Create HubSpot ticket action"
  action_category    = "${module.data_action.integration_name}"
  integration_id     = "${module.data_action.integration_id}"
  bearer_token       = var.bearer_token
}

// Add DataAction for creating workitem
module "create-workitem" {
  source             = "./modules/actions/create-workitem"
  action_name        = "Create workitem action"
  action_category    = "${module.data_action.integration_name}"
  integration_id     = "${module.data_action.integration_id}"
  bearer_token       = var.bearer_token
}

// Add group
module "create_group" {
  source             = "./modules/group"
  user_id            = data.genesyscloud_user.user.id
}

// Add Workbin for creating HubSpot tickets
module "create_workbin" {
  source             = "./modules/workbin"
  division_id        = var.division_id
}

// Add Schema Attributes for creating HubSpot tickets
module "create_schemaattributes" {
  source             = "./modules/schemaattributes"
}

// Add Worktype for creating HubSpot tickets
module "create_worktype" {
  source             = "./modules/worktype"
  division_id        = var.division_id
  workbin_id         = module.create_workbin.workbin_id
  schema_id          = module.create_schemaattributes.schema_id
  depends_on         = [module.create_workbin, module.create_schemaattributes]
}

// Add Integration for creating HubSpot tickets
module "create_integration" {
   source             = "./modules/integration"
   account_id         = var.account_id
   group_id           = module.create_group.group_id
   depends_on         = [module.create_group]
}

