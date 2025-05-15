variable "name" {
  description = "Name of the GitHub repository"
  type        = string
  nullable    = false
}

# TODO / Remove default values from variables / it will use provider's defaults
variable "description" {
  description = "Description of the GitHub repository"
  type        = string
  default     = ""
  nullable    = false
}

variable "visibility" {
  description = "Visibility of the GitHub repository (public, private, or internal)"
  type        = string
  default     = "private"
  nullable    = false

  validation {
    condition     = contains(["public", "private", "internal"], var.visibility)
    error_message = "The visibility must be one of: public, private, internal"
  }
}

variable "template" {
  description = "Template configuration for the GitHub repository"
  type = object({
    owner                = string
    repository           = string
    include_all_branches = bool
  })
  default  = null
  nullable = true
}

variable "homepage_url" {
  description = "URL of a page describing the project."
  type        = string
  default     = null
  nullable    = true
}

variable "topics" {
  description = "List of topics to add to the repository"
  type        = list(string)
  default     = []
  nullable    = false
}

variable "has_issues" {
  description = "Set to true to enable the GitHub Issues features on the repository"
  type        = bool
  default     = true
  nullable    = false
}

variable "has_projects" {
  description = "Set to true to enable the GitHub Projects features on the repository"
  type        = bool
  default     = false
  nullable    = false
}

variable "has_wiki" {
  description = "Set to true to enable the GitHub Wiki features on the repository"
  type        = bool
  default     = false
  nullable    = false
}

variable "has_discussions" {
  description = "Set to true to enable GitHub Discussions on the repository"
  type        = bool
  default     = false
  nullable    = false
}

variable "has_downloads" {
  description = "Set to true to enable the GitHub Downloads features on the repository (deprecated)"
  type        = bool
  default     = false
  nullable    = false
}

variable "allow_merge_commit" {
  description = "Set to false to disable merge commits on the repository"
  type        = bool
  default     = true
  nullable    = false
}

variable "merge_commit_title" {
  description = "The format of the commit message when using merge commit. Can be one of: PR_TITLE, MERGE_MESSAGE"
  type        = string
  default     = "PR_TITLE"
  nullable    = false
  validation {
    condition     = contains(["PR_TITLE", "MERGE_MESSAGE"], var.merge_commit_title)
    error_message = "merge_commit_title must be one of: PR_TITLE, MERGE_MESSAGE"
  }
}

variable "merge_commit_message" {
  description = "The format of the commit message body when using merge commit. Can be one of: PR_BODY, COMMIT_MESSAGES, BLANK"
  type        = string
  default     = "PR_BODY"
  nullable    = false
  validation {
    condition     = contains(["PR_BODY", "COMMIT_MESSAGES", "BLANK"], var.merge_commit_message)
    error_message = "merge_commit_message must be one of: PR_BODY, COMMIT_MESSAGES, BLANK"
  }
}

variable "merge_commit_validation" {
  type     = string
  default  = "_placeholder_for_validation"
  nullable = false
  validation {
    condition = contains([
      "PR_TITLE:PR_BODY",
      "PR_TITLE:BLANK",
      "MERGE_MESSAGE:PR_TITLE",
      var.merge_commit_validation
    ], "${var.merge_commit_title}:${var.merge_commit_message}")
    error_message = "Invalid combination of merge_commit_title and merge_commit_message. Valid combinations are: PR_TITLE and PR_BODY, PR_TITLE and BLANK, MERGE_MESSAGE and PR_TITLE"
  }
}


variable "allow_auto_merge" {
  description = "Set to true to allow auto-merging pull requests on the repository"
  type        = bool
  default     = false
  nullable    = false
}

variable "allow_squash_merge" {
  description = "Set to false to disable squash merges on the repository"
  type        = bool
  default     = true
  nullable    = false
}

variable "squash_merge_commit_title" {
  description = "The format of the commit message when using squash merge. Can be one of: PR_TITLE, COMMIT_OR_PR_TITLE"
  type        = string
  default     = "COMMIT_OR_PR_TITLE"
  nullable    = false
  validation {
    condition     = contains(["PR_TITLE", "COMMIT_OR_PR_TITLE"], var.squash_merge_commit_title)
    error_message = "squash_merge_commit_title must be one of: PR_TITLE, COMMIT_OR_PR_TITLE"
  }
}

variable "squash_merge_commit_message" {
  description = "The format of the commit message body when using squash merge. Can be one of: PR_BODY, COMMIT_MESSAGES, BLANK"
  type        = string
  default     = "COMMIT_MESSAGES"
  nullable    = false
  validation {
    condition     = contains(["PR_BODY", "COMMIT_MESSAGES", "BLANK"], var.squash_merge_commit_message)
    error_message = "squash_merge_commit_message must be one of: PR_BODY, COMMIT_MESSAGES, BLANK"
  }
}

variable "allow_rebase_merge" {
  description = "Set to false to disable rebase merges on the repository"
  type        = bool
  default     = true
  nullable    = false
}

variable "delete_branch_on_merge" {
  description = "Automatically delete head branch after a pull request is merged"
  type        = bool
  default     = false
  nullable    = false
}

variable "is_template" {
  description = "Set to true to tell GitHub that this is a template repository"
  type        = bool
  default     = false
  nullable    = false

  validation {
    condition     = var.template == null || !var.is_template
    error_message = "is_template cannot be true when using a template repository"
  }
}

variable "default_branch" {
  description = "The name of the default branch of the repository."
  type        = string
  default     = "main"
  nullable    = false

  validation { // TODO / review
    condition     = var.template != null || var.auto_init == true && var.default_branch == "main" || length(var.branches) == 0 || length([for branch in var.branches : branch.name if branch.name == var.default_branch]) > 0
    error_message = "The default_branch must be included in the branches list if branches are defined and template is not used"
  }
}

variable "archived" {
  description = "Specifies if the repository should be archived"
  type        = bool
  default     = false
  nullable    = false
}

variable "archive_on_destroy" {
  description = "Set to true to archive the repository instead of deleting it when the resource is destroyed"
  type        = bool
  default     = true
  nullable    = false
}

variable "web_commit_signoff_required" {
  description = "Require contributors to sign off on web-based commits"
  type        = bool
  default     = false
  nullable    = false
}

variable "vulnerability_alerts" {
  description = "Set to true to enable security alerts for vulnerable dependencies. Will be automatically enabled if enable_dependabot_security_updates is true."
  type        = bool
  default     = false
  nullable    = false
}

variable "auto_init" {
  description = "Set to true to produce an initial commit in the repository. Ignored if template is used."
  type        = bool
  default     = false
  nullable    = false
}

variable "gitignore_template" {
  description = "Use the name of the template without the extension. For example, 'Haskell'"
  type        = string
  default     = null
  nullable    = true
}

variable "license_template" {
  description = "Use the name of the template without the extension. For example, 'mit' or 'mpl-2.0'"
  type        = string
  default     = null
  nullable    = true
}

variable "pages" {
  description = "The repository's GitHub Pages configuration. Do not apply this configuration before the first apply if the source branch does not exist. Requires a paid GH plan."
  type = object({
    build_type = optional(string, "legacy")
    cname      = optional(string, null)
    source = object({
      branch = string
      path   = string
    })
  })
  default  = null
  nullable = true
  validation {
    condition = var.pages == null || (try(var.pages.source.branch, "") == var.default_branch || (
      length([for branch in var.branches : branch.name if branch.name == try(var.pages.source.branch, "")]) > 0
    ))
    error_message = "The GitHub Pages branch must be either the default branch or one of the branches defined in the branches variable."
  }
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
  default  = null
  nullable = true
}

variable "branches" {
  description = "List of branch configurations to create"
  type = list(object({
    name = string
    # default       = optional(bool) # TODO use it instead of default_branch
    source_branch = optional(string)
    source_sha    = optional(string)
    # TODO add missing options from https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_protection
    protection = optional(object({
      enforce_admins = optional(bool)
      required_status_checks = optional(object({
        strict   = optional(bool)
        contexts = optional(list(string))
      }))
      required_pull_request_reviews = optional(object({
        dismiss_stale_reviews           = optional(bool)
        restrict_dismissals             = optional(bool)
        dismissal_restrictions          = optional(list(string))
        require_code_owner_reviews      = optional(bool)
        required_approving_review_count = optional(number)
      }))
    }))
  }))
  default  = []
  nullable = false
}

variable "github_actions_variables" {
  type = list(object({
    name  = string
    value = string
  }))
  default     = []
  nullable    = false
  description = "GitHub Actions variables to set on the repository"
}

variable "github_actions_secrets" {
  type = list(object({
    name  = string
    value = string
  }))
  default     = []
  nullable    = false
  description = "GitHub Actions secrets to set on the repository"
}

variable "environments" {
  description = "GitHub repository environments to create"
  type = list(object({
    name = string
    reviewers = optional(object({
      teams = optional(list(string), [])
      users = optional(list(string), [])
    }))
    protected = optional(bool, false)
    variables = optional(list(object({
      name  = string
      value = string
    })), [])
    secrets = optional(list(object({
      name  = string
      value = string
    })), [])
  }))
  default  = []
  nullable = false
}

variable "users" {
  description = "List of repository collaborators to add to the repository"
  type = list(object({
    username   = string
    permission = string # pull, push, admin, maintain, triage
  }))
  default  = []
  nullable = false
}

variable "teams" {
  description = "List of repository teams to add to the repository"
  type = list(object({
    team_id    = string
    permission = string
  }))
  default  = []
  nullable = false
}

# Variable disabled temporarily due to bug in github_repository_tag_protection resource
# https://github.com/integrations/terraform-provider-github/issues/2477
# variable "tag_protections" {
#   description = "List of tag protection patterns to apply to the repository"
#   type = list(object({
#     pattern       = string
#     allow_force   = optional(bool, false)
#     allow_deletions = optional(bool, false)
#   }))
#   default = [{
#     pattern = "v[0-9]+.[0-9]+.[0-9]+"  # Default semantic versioning pattern
#   }]
#   nullable = false
# }

variable "custom_properties" {
  description = "Custom properties to set on the repository. Must be defined on the organization level first."
  type = list(object({
    property_name  = string
    property_value = string
    property_type  = optional(string, "string")
  }))
  default  = []
  nullable = false
}

variable "enable_dependabot_security_updates" {
  description = "Whether to enable Dependabot security updates for the repository. This automatically enables vulnerability alerts as well."
  type        = bool
  default     = true
  nullable    = false
}

variable "use_repository_topics_resource" {
  description = "Whether to use github_repository_topics resource instead of setting topics in the github_repository resource. This is useful for managing topics separately."
  type        = bool
  default     = false
  nullable    = false
}

variable "webhooks" {
  description = "List of webhook configurations to create for the repository"
  type = list(object({
    url          = string
    content_type = string
    secret       = optional(string)
    insecure_ssl = optional(bool, false)
    active       = optional(bool, true)
    events       = list(string)
  }))
  default  = []
  nullable = false
}

variable "deploy_keys" {
  description = "List of SSH deploy keys to add to the repository"
  type = list(object({
    title     = string
    key       = string
    read_only = optional(bool, true)
  }))
  default  = []
  nullable = false
}

variable "github_repository_files" {
  description = "A map of files to create in the repository. Each key is the file path, and the value is a map with file content and other properties."
  type = map(object({
    content                         = string
    branch                          = optional(string, null)
    commit_sha                      = optional(string, null)
    commit_message                  = optional(string, "Managed by Terraform")
    commit_author                   = optional(string, null)
    commit_email                    = optional(string, null)
    overwrite_on_create             = optional(bool, false)
    autocreate_branch               = optional(bool, true)
    autocreate_branch_source_branch = optional(string, null)
    autocreate_branch_source_sha    = optional(string, null)
  }))
  default  = {}
  nullable = false
}

variable "issue_label" {
  description = "A list of issue label"
  type = list(object({
    name        = string
    color       = string
    description = optional(string, "")
  }))
  default = []
}

variable "autolink_references" {
  description = "A list of autolink references to create for the repository"
  type = list(object({
    key_prefix          = string
    target_url_template = string
    is_alphanumeric     = optional(bool)
  }))
  default = []

}

variable "projects" {
  description = "A list of project configurations to create for the repository"
  type = list(object({
    name       = string
    repository = string
    body       = optional(string, null)
  }))
  default = []
}



# variable "ruleset" {
#   description = "add later"
#   type = list(object({
#     name = string
#     target = string # TODO / add validation branch or tag
#     enforcement = string # TODO / add validation for values: disabled, active, evaluate
#   }))
#   default = []

# }