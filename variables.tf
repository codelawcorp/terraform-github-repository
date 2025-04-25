variable "name" {
  description = "Name of the GitHub repository"
  type        = string
}

variable "description" {
  description = "Description of the GitHub repository"
  type        = string
  default     = ""
}

variable "visibility" {
  description = "Visibility of the GitHub repository (public, private, or internal)"
  type        = string
  default     = "private"
}

variable "template" {
  description = "Template configuration for the GitHub repository"
  type = object({
    owner                = string
    repository          = string
    include_all_branches = bool
  })
  default = {
    owner                = ""
    repository          = ""
    include_all_branches = false
  }
}