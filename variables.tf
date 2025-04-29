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
    repository           = string
    include_all_branches = bool
  })
  default = {
    owner                = ""
    repository           = ""
    include_all_branches = false
  }
}

variable "homepage_url" {
  description = "URL of a page describing the project"
  type        = string
  default     = ""
}

variable "topics" {
  description = "List of topics to add to the repository"
  type        = list(string)
  default     = []
}

variable "has_issues" {
  description = "Set to true to enable the GitHub Issues features on the repository"
  type        = bool
  default     = true
}

variable "has_projects" {
  description = "Set to true to enable the GitHub Projects features on the repository"
  type        = bool
  default     = false
}

variable "has_wiki" {
  description = "Set to true to enable the GitHub Wiki features on the repository"
  type        = bool
  default     = false
}

variable "has_downloads" {
  description = "Set to true to enable the GitHub Downloads features on the repository"
  type        = bool
  default     = false
}

variable "allow_merge_commit" {
  description = "Set to false to disable merge commits on the repository"
  type        = bool
  default     = true
}

variable "allow_squash_merge" {
  description = "Set to false to disable squash merges on the repository"
  type        = bool
  default     = true
}

variable "allow_rebase_merge" {
  description = "Set to false to disable rebase merges on the repository"
  type        = bool
  default     = true
}

variable "delete_branch_on_merge" {
  description = "Automatically delete head branch after a pull request is merged"
  type        = bool
  default     = false
}

variable "is_template" {
  description = "Set to true to tell GitHub that this is a template repository"
  type        = bool
  default     = false
}

variable "default_branch" {
  description = "The name of the default branch of the repository"
  type        = string
  default     = "main"
}

variable "archived" {
  description = "Specifies if the repository should be archived"
  type        = bool
  default     = false
}

variable "pages" {
  description = "The repository's GitHub Pages configuration"
  type = object({
    source = object({
      branch = string
      path   = string
    })
  })
  default = null
}

variable "security_and_analysis" {
  description = "Security and analysis features for the repository"
  type = object({
    advanced_security = object({
      status = string
    })
    secret_scanning = object({
      status = string
    })
    secret_scanning_push_protection = object({
      status = string
    })
  })
  default = null
}