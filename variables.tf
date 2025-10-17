variable "name" {
  description = "Name of the GitHub repository"
  type        = string
  nullable    = false
}

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
  description = "A repo to use as a template for the new repository. ⚠️ Removing this block changes default branch to 'prod'. ⚠️"
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
  default     = false
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
    condition     = var.allow_squash_merge == true && contains(["PR_TITLE", "COMMIT_OR_PR_TITLE"], var.squash_merge_commit_title)
    error_message = "allow_squash_merge must be enabled, squash_merge_commit_title must be one of: PR_TITLE, COMMIT_OR_PR_TITLE"
  }
}

variable "squash_merge_commit_message" {
  description = "The format of the commit message body when using squash merge. Can be one of: PR_BODY, COMMIT_MESSAGES, BLANK"
  type        = string
  default     = "COMMIT_MESSAGES"
  nullable    = false
  validation {
    condition     = var.allow_squash_merge == true && contains(["PR_BODY", "COMMIT_MESSAGES", "BLANK"], var.squash_merge_commit_message)
    error_message = "allow_squash_merge must be enabled, squash_merge_commit_message must be one of: PR_BODY, COMMIT_MESSAGES, BLANK"
  }
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
  default     = null
  nullable    = true

}

variable "merge_commit_message" {
  description = "The format of the commit message body when using merge commit. Can be one of: PR_BODY, COMMIT_MESSAGES, BLANK"
  type        = string
  default     = null
  nullable    = true


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

# TODO / remove this variable. Use default attribute on the branches list or pick the first branch in the list.
# variable "default_branch" {
#   description = "The name of the default branch of the repository. ⚠️ Ignored if template is set. ⚠️. 'main' is not allowed."
#   type        = string
#   default     = "prod"
#   nullable    = false

#   validation {
#     condition     = var.default_branch != "main"
#     error_message = "default_branch cannot be 'main'. Use 'prod' instead or another name instead."
#   }
#   # validation {
#   #   condition     = (var.template == null && var.default_branch != null) || (var.template != null && var.default_branch == null)
#   #   error_message = "Default branch must be set only if template is not used"
#   # }
#   # validation { // TODO / write tests for different combinations of template, auto_init, branches, default_branch / Some tests must fail, other succees (use assertions)
#   #   # condition     = var.template != null || var.auto_init == true && var.default_branch == "main" || length(var.branches) == 0 || length([for branch in var.branches : branch.name if branch.name == var.default_branch]) > 0
#   #   condition     = var.template == null && var.default_branch == var.default_branch
#   #   error_message = "Default branch should not be set if the template is used. You can set default branch later, after the repository is created and template attribute is removed."
#   # }
# }

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

# variable "auto_init" { # Deprecated by this module. Might be removed in the future.
#   description = "Set to true to produce an initial commit in the repository. Is not compatible with template."
#   type        = bool
#   default     = false
#   nullable    = false

#   validation {
#     condition     = var.template == null || ! var.auto_init
#     error_message = "auto_init cannot be true when using a template repository"
#   }
# }

variable "gitignore_template" {
  description = "Use the name of the template without the extension. For example, 'Haskell'" # Full list is here: https://github.com/github/gitignore
  type        = string
  default     = null
  nullable    = true
}

variable "license_template" {
  description = "Use the name of the template without the extension. For example, 'mit' or 'mpl-2.0'" # Full list is here: https://github.com/github/choosealicense.com/tree/gh-pages/_licenses
  type        = string
  default     = null
  nullable    = true
}

variable "pages" {
  description = "GitHub Pages configuration for the repository. ⚠️ Note: Requires a paid GitHub plan and ⚠️ the source branch must exist before applying this configuration - the first apply always fails - disable on the first apply. ⚠️ "
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
  # validation {
  #   condition = var.pages == null || (try(var.pages.source.branch, "") == var.default_branch || (
  #     length([for branch in var.branches : branch.name if branch.name == try(var.pages.source.branch, "")]) > 0
  #   ))
  #   error_message = "The GitHub Pages branch must be either the default branch or one of the branches defined in the branches variable."
  # }
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
  description = "List of branch configurations to create" # More info here: https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch
  type = list(object({
    name          = string
    source_branch = optional(string) # By default, the source branch is the default branch.
    source_sha    = optional(string)
    # https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_protection
    protection = optional(object({ # Empty object means to protect with defaults
      # `pattern` is always name of the branch. This is how this module works.
      enforce_admins                  = optional(bool)
      require_signed_commits          = optional(bool)
      required_linear_history         = optional(bool)
      require_conversation_resolution = optional(bool)
      allows_deletions                = optional(bool)
      allows_force_pushes             = optional(bool)
      force_push_bypassers            = optional(list(string))
      lock_branch                     = optional(bool)
      required_status_checks = optional(object({
        strict   = optional(bool)
        contexts = optional(list(string))
      }))
      required_pull_request_reviews = optional(object({
        dismiss_stale_reviews           = optional(bool)
        restrict_dismissals             = optional(bool)
        dismissal_restrictions          = optional(list(string))
        pull_request_bypassers          = optional(list(string))
        require_code_owner_reviews      = optional(bool)
        required_approving_review_count = optional(number)
        require_last_push_approval      = optional(bool)
      }))
      restrict_pushes = optional(object({
        blocks_creations = optional(bool)
        push_allowances  = optional(list(string))
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
  type = list(object({ # https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_environment
    name                = string
    wait_timer          = optional(number, null)
    can_admins_bypass   = optional(bool, null)
    prevent_self_review = optional(bool, null)
    reviewers = optional(object({
      teams = optional(list(string), []) # This is a team id, not a team name
      users = optional(list(string), []) # This is a user id, not a username
    }))
    protected = optional(bool, false) # This is instead of deployment_branch_policy block. This module enforces 1:1 environment and branch name. Open a PR or issue if you disagree.
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
  description = "List of SSH deploy keys to add to the repository. Must be allowed on the org level."
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

variable "github_actions_repository_permissions" {
  description = "GitHub Actions repository permissions configuration"
  type        = any # https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_ruleset
  default     = null
  nullable    = true
}



# 410 Projects (classic) has been deprecated in favor of the new Projects experience. []
# variable "projects" {
#   description = "A list of project configurations to create for the repository"
#   type = list(object({
#     name = string
#     body = optional(string, null)
#   }))
#   default = []
# }



variable "ruleset" {
  description = "add later"
  type = list(object({
    name        = string
    target      = string # TODO / add validation branch or tag
    enforcement = string # TODO / add validation for values: disabled, active, evaluate
  }))
  default = []

}

variable "bootstrap_tf_cloud" {
  description = "When not empty, congigures Terraform cloud backend and GitHub Aciton. After inital apply most of changes to this block are IGNORED."
  type = object({
    tf_cloud_organization = optional(string)
    tf_cloud_workspace    = optional(string)
    terraform_version     = optional(string, "latest") # https://github.com/hashicorp/setup-terraform?tab=readme-ov-file#inputs
    tfe_token             = optional(string)           # After the first apply, all further changes are ignored.
    github_token          = optional(string)           # After the first apply, all further changes are ignored.
  })
  default  = null
  nullable = true
}