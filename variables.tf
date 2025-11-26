variable "name" {
  description = "Name of the GitHub repository"
  type        = string
  nullable    = false
}

variable "description" {
  description = "Description of the GitHub repository"
  default     = null
  type        = string
  nullable    = true
}

variable "visibility" {
  description = "Visibility of the GitHub repository (public, private, or internal)"
  type        = string
  default     = "private"
  nullable    = true

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

variable "fork" {
  description = "Set to true to create a fork of the repository"
  type        = bool
  default     = false
  nullable    = false
}

variable "source_owner" {
  description = "Owner of the source repository"
  type        = string
  default     = null
  nullable    = true
}

variable "source_repo" {

  description = "Name of the source repository"
  type        = string
  default     = null
  nullable    = true
}

variable "topics" {
  description = "List of topics to add to the repository"
  type        = list(string)
  default     = null
  nullable    = true
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

variable "default_branch" {
  description = "The name of the default branch of the repository. ⚠️ Ignored if template is set. ⚠️. 'main' is not allowed."
  type        = string
  default     = "main"
  nullable    = false

  # validation {
  #   condition     = var.default_branch != "main"
  #   error_message = "default_branch cannot be 'main'. Use any other name. Default is `prod` "
  # }
  # validation {
  #   condition     = (var.template == null && var.default_branch != null) || (var.template != null && var.default_branch == null)
  #   error_message = "Default branch can be set only if template is not used"
  # }
  # validation {
  #   # condition     = var.template != null || var.auto_init == true && var.default_branch == "main" || length(var.branches) == 0 || length([for branch in var.branches : branch.name if branch.name == var.default_branch]) > 0
  #   condition     = var.default_branch != null && var.template != null
  #   error_message = "Default branch can not be set if the template is used. You can set default branch later, after the repository is created and template attribute is removed."
  # }
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

variable "allow_update_branch" {
  description = "Set to true to allow updating the default branch of the repository"
  type        = bool
  default     = false
  nullable    = false
}

variable "ignore_vulnerability_alerts_during_read" {
  description = "Set to `true` to not call the vulnerability alerts endpoint so the resource can also be used without admin permissions during read."
  type        = bool
  default     = false
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
    source = optional(object({
      branch = string
      path   = string
    }), null)
  })
  default  = null
  nullable = true
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
    source_branch = optional(string) # By default, the source branch is the default branch. Ignored after the initial branch creation.
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

variable "actions_variables" {
  type = list(object({
    name  = string
    value = string
  }))
  default     = []
  nullable    = false
  description = "GitHub Actions variables to set on the repository"
}

variable "actions_secrets" {
  type = list(object({
    name             = string
    value            = string
    destroy_on_drift = optional(bool, true)
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

variable "teams" { #
  description = "List of repository teams to add to the repository"
  type = list(object({ # https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_collaborator
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
  type = list(object({ # https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_custom_property
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
  type = list(object({ # https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_deploy_key
    title     = string
    key       = string
    read_only = optional(bool, true)
  }))
  default  = []
  nullable = false
}

variable "repository_files" {
  description = "A map of files to create in the repository. Each key is the file path, and the value is a map with file content and other properties. ! Files can't be managed if the repository is archived."
  type = map(object({ # https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file
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

variable "issue_labels" {
  description = "A list of issue label"
  type = list(object({ # https://registry.terraform.io/providers/integrations/github/latest/docs/resources/issue_label
    name        = string
    color       = string
    description = optional(string, "")
  }))
  default = []
}

variable "autolink_references" {
  description = "A list of autolink references to create for the repository"
  type = list(object({ # https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_autolink_reference
    key_prefix          = string
    target_url_template = string
    is_alphanumeric     = optional(bool)
  }))
  default = []

}

variable "actions_repository_permissions" {
  description = "GitHub Actions repository permissions configuration"
  type = object({
    allowed_actions = optional(string)
    enabled         = optional(bool)
    allowed_actions_config = optional(object({
      github_owned_allowed = optional(bool)
      patterns_allowed     = optional(list(string))
      verified_allowed     = optional(bool)
    }))
  })

  default  = null
  nullable = true
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


variable "rulesets" {
  description = "List of GitHub repository ruleset configurations"

  type = list(object({
    name        = string
    target      = string
    enforcement = string

    rules = optional(object({
      branch_name_pattern = optional(object({
        operator = optional(string)
        pattern  = optional(string)
        name     = optional(string)
        negate   = optional(bool)
      }))

      commit_author_email_pattern = optional(object({
        operator = optional(string)
        pattern  = optional(string)
        name     = optional(string)
        negate   = optional(bool)
      }))

      commit_message_pattern = optional(object({
        operator = optional(string)
        pattern  = optional(string)
        name     = optional(string)
        negate   = optional(bool)
      }))

      committer_email_pattern = optional(object({
        operator = optional(string)
        pattern  = optional(string)
        name     = optional(string)
        negate   = optional(bool)
      }))

      merge_queue = optional(list(object({
        check_response_timeout_minutes    = optional(number)
        grouping_strategy                 = optional(string)
        max_entries_to_build              = optional(number)
        max_entries_to_merge              = optional(number)
        merge_method                      = optional(string)
        min_entries_to_merge              = optional(number)
        min_entries_to_merge_wait_minutes = optional(number)
      })))

      pull_request = optional(list(object({
        dismiss_stale_reviews_on_push     = optional(bool)
        require_code_owner_review         = optional(bool)
        require_last_push_approval        = optional(bool)
        required_approving_review_count   = optional(number)
        required_review_thread_resolution = optional(bool)
      })))

      required_deployments = optional(list(object({
        required_deployment_environments = optional(list(string))
      })))

      required_status_checks = optional(list(object({
        required_check = optional(list(object({
          context        = optional(string)
          integration_id = optional(number)
        })))
        strict_required_status_checks_policy = optional(bool)
        do_not_enforce_on_create             = optional(bool)
      })))

      tag_name_pattern = optional(object({
        operator = optional(string)
        pattern  = optional(string)
        name     = optional(string)
        negate   = optional(bool)
      }))

      required_code_scanning = optional(object({
        required_code_scanning_tool = optional(object({
          alerts_threshold          = optional(string)
          security_alerts_threshold = optional(string)
          tool                      = optional(string)
        }))
      }))

      # Basic ref protection rules
      creation                      = optional(bool)
      update                        = optional(bool)
      update_allows_fetch_and_merge = optional(bool)
      deletion                      = optional(bool)
      required_linear_history       = optional(bool)
      required_signatures           = optional(bool)
      non_fast_forward              = optional(bool)
    }))
  }))

  default = []
}

variable "bootstrap_me" {
  description = "Set to `true` to init a git project in the current module directory and to add the newly created repository as an upstream."
  type        = bool
  default     = false
  nullable    = false
}