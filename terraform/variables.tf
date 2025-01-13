variable "client_id" {
  type        = string
  description = "The OAuth (Client Credentails) Client ID to be used by Data Actions"
}

variable "client_secret" {
  type        = string
  description = "The OAuth (Client Credentails) Client Secret to be used by Data Actions"
}

variable "account_id" {
  type        = string
  description = "The Account ID to be used by Integration"
}

variable "division_id" {
  type        = string
  description = "The Division ID to be used by Task Management"
}

variable "email" {
  type        = string
  description = "The Account Email address to be used by Groups"
}

variable "bearer_token" {
  type        = string
  description = "The Bearer Token to be used by Data Actions"
}