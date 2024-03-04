variable "teams" {
  type = map(object({
    description = string
    privacy     = string
    maintainers = list(string)
    members     = list(string)
    parent_id   = string
  }))
  description = "A map of teams to create where the key is the team name and the value is the configuration. If the team does not have a parent team, the parent_id should be an empty string."
}

variable "preexisting_teams" {
  type = map(object({
    bucket      = string
    prefix      = string
    output_name = string
    maintainers = list(string)
    members     = list(string)
    parent_id   = string
  }))
  description = "A map of existing teams where the key is the team name and the value is the configuration. If the team does not have a parent team, the parent_id should be an empty string."
  default     = {}
}
