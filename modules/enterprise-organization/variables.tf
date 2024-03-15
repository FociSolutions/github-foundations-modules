variable "enterprise_id" {
  type        = string
  description = "The id of the enterprise account to create the organization under."
}

variable "name" {
  type        = string
  description = "The name of the organization to create."
}

variable "display_name" {
  type        = string
  description = "The display name of the organization. If set to an empty string then `name` will be used instead"
  default     = ""
}

variable "description" {
  type        = string
  description = "The description of the organization."
  default     = ""
}

variable "billing_email" {
  type        = string
  description = "The email to use for the organizations billing."
}

variable "admin_logins" {
  type        = list(string)
  description = "List of organization owner usernames."
}
