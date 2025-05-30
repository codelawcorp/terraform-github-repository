variable "default_branch" {
  description = "The name of the default branch of the repository. ⚠️ Ignored if template is set. ⚠️. 'main' is not allowed."
  type        = string
  default     = "prod"
}