variable "pages" {
  description = "Can be applied after the first apply."
  type = object({
    build_type = optional(string, "legacy")
    cname      = optional(string, null)
    source = object({
      branch = string
      path   = string
    })
  })
  default = null
}

variable "user_id" {
  description = "User ID to use for the repository"
  type        = string
  default     = null
}
