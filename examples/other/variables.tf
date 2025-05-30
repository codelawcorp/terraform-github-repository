variable "default_branch" {
  description = "The name of the default branch of the repository. ⚠️ Ignored if template is set. ⚠️. 'main' is not allowed."
  type        = string
  default     = "prod"
}

variable "template" {
  description = "The template repository to use for the repository."
  type        = object({
    owner = string
    repository = string
    include_all_branches = optional(bool, false)
  })
  default     = null
}