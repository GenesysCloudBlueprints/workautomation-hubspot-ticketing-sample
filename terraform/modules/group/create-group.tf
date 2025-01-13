resource "genesyscloud_group" "sample_group" {
  name          = "MCT Hubspot Group"
  description   = "Group for Testers"
  type          = "official"
  visibility    = "public"
  rules_visible = true
  owner_ids     = [var.user_id]
  member_ids    = [var.user_id]
}