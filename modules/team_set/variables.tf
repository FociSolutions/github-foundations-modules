variable "teams" {
  type = map(object({
    description = string
    privacy     = string
    maintainers = list(string)
    members     = list(string)
    parent_id   = string
    import      = optional(bool)
  }))
  description = "A map of teams to create where the key is the team name and the value is the configuration. If the team does not have a parent team, the parent_id should be an empty string."
}
