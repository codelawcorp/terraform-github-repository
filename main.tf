# output "repo_debug" {
#   value = github_repository.this
# }

# output "debug_default_branch" {
#   value = github_branch_default.this
# }


resource "github_repository" "this" {
  name        = var.name
  description = var.description
  visibility  = var.visibility

  homepage_url = var.homepage_url
  # topics       = var.use_repository_topics_resource ? null : var.topics # Using a dedicated resource for topics.

  has_issues      = var.has_issues
  has_projects    = var.has_projects
  has_wiki        = var.has_wiki
  has_discussions = var.has_discussions
  has_downloads   = var.has_downloads

  allow_merge_commit   = var.allow_merge_commit
  merge_commit_title   = var.merge_commit_title
  merge_commit_message = var.merge_commit_message

  allow_auto_merge            = var.allow_auto_merge
  allow_squash_merge          = var.allow_squash_merge
  squash_merge_commit_title   = var.squash_merge_commit_title
  squash_merge_commit_message = var.squash_merge_commit_message
  allow_rebase_merge          = var.allow_rebase_merge
  delete_branch_on_merge      = var.delete_branch_on_merge


  is_template = var.is_template
  archived    = var.archived

  web_commit_signoff_required = var.web_commit_signoff_required
  vulnerability_alerts        = var.vulnerability_alerts || var.enable_dependabot_security_updates
  auto_init                   = var.template == null ? var.auto_init : false
  gitignore_template          = var.gitignore_template
  license_template            = var.license_template
  archive_on_destroy          = var.archive_on_destroy

  # TODO / add allow_update_branch
  # TODO / add ignore_vulnerability_alerts_during_read 

  dynamic "template" {
    for_each = var.template != null ? [var.template] : []
    content {
      owner                = template.value.owner
      repository           = template.value.repository
      include_all_branches = template.value.include_all_branches
    }
  }
  lifecycle {
    ignore_changes = [template] # A bug in provider - perpetual changes in plan when `include_all_branches` is true.
  }

  dynamic "pages" { #  GitHub provider issue: pages branch must exist at apply time / chicken-egg problem
    for_each = var.pages != null ? [var.pages] : []
    content {
      build_type = pages.value.build_type
      cname      = pages.value.cname
      source {
        branch = pages.value.source.branch
        path   = pages.value.source.path
      }
    }
  }

  dynamic "security_and_analysis" {
    for_each = var.security_and_analysis != null ? [var.security_and_analysis] : []
    content {
      dynamic "advanced_security" {
        for_each = security_and_analysis.value.advanced_security != null ? [security_and_analysis.value.advanced_security] : []
        content {
          status = advanced_security.value.status
        }
      }

      dynamic "secret_scanning" {
        for_each = security_and_analysis.value.secret_scanning != null ? [security_and_analysis.value.secret_scanning] : []
        content {
          status = secret_scanning.value.status
        }
      }

      dynamic "secret_scanning_push_protection" {
        for_each = security_and_analysis.value.secret_scanning_push_protection != null ? [security_and_analysis.value.secret_scanning_push_protection] : []
        content {
          status = secret_scanning_push_protection.value.status
        }
      }
    }
  }
}

resource "github_branch_default" "this" { # Changing it RENAMES the current default branch.
  count      = var.auto_init == true || var.template != null ? 1 : 0
  repository = github_repository.this.name
  branch     = var.auto_init == true ? "main" : var.default_branch
  rename     = false # TODO / experiment with it and add a variable # https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_default
}

resource "github_branch" "this" {
  # Avoiding ` 422 Cannot delete the default branch []` error.
  for_each = { for branch in var.branches : branch.name => branch if branch.name != var.default_branch }

  repository    = github_repository.this.name
  branch        = each.value.name
  source_branch = coalesce(each.value.source_branch, github_branch_default.this[0].branch)
  source_sha    = each.value.source_sha


}

resource "github_branch_protection" "this" {
  for_each = { for branch in var.branches : branch.name => branch if branch.protection != null }

  repository_id                   = github_repository.this.node_id
  pattern                         = each.value.name
  enforce_admins                  = try(each.value.protection.enforce_admins, null)
  require_signed_commits          = try(each.value.protection.require_signed_commits, null)
  required_linear_history         = try(each.value.protection.required_linear_history, null)
  require_conversation_resolution = try(each.value.protection.require_conversation_resolution, null)
  allows_deletions                = try(each.value.protection.allows_deletions, false)
  allows_force_pushes             = try(each.value.protection.allows_force_pushes, null)
  force_push_bypassers            = try(each.value.protection.force_push_bypassers, [])
  lock_branch                     = try(each.value.protection.lock_branch, null)

  dynamic "required_status_checks" {
    for_each = each.value.protection.required_status_checks != null ? [each.value.protection.required_status_checks] : []
    content {
      strict   = try(required_status_checks.value.strict, null)
      contexts = try(required_status_checks.value.contexts, [])
    }
  }

  dynamic "required_pull_request_reviews" {
    for_each = each.value.protection.required_pull_request_reviews != null ? [each.value.protection.required_pull_request_reviews] : []
    content {
      dismiss_stale_reviews           = try(required_pull_request_reviews.value.dismiss_stale_reviews, null)
      restrict_dismissals             = try(required_pull_request_reviews.value.restrict_dismissals, null)
      dismissal_restrictions          = try(required_pull_request_reviews.value.dismissal_restrictions, [])
      pull_request_bypassers          = try(required_pull_request_reviews.value.pull_request_bypassers, [])
      require_code_owner_reviews      = try(required_pull_request_reviews.value.require_code_owner_reviews, null)
      required_approving_review_count = try(required_pull_request_reviews.value.required_approving_review_count, 1)
      require_last_push_approval      = try(required_pull_request_reviews.value.require_last_push_approval, null)
    }
  }
  dynamic "restrict_pushes" {
    for_each = each.value.protection.restrict_pushes != null ? [each.value.protection.restrict_pushes] : []
    content {
      blocks_creations = try(restrict_pushes.value.blocks_creations, null)
      push_allowances  = try(restrict_pushes.value.push_allowances, [])
    }
  }

}

resource "github_actions_variable" "this" {
  for_each      = { for k, v in var.github_actions_variables : v.name => v }
  repository    = github_repository.this.name
  variable_name = each.key
  value         = each.value.value
}

resource "github_repository_collaborator" "this" {
  for_each   = { for user in var.users : user.username => user }
  repository = github_repository.this.name
  username   = each.value.username
  permission = each.value.permission
}

resource "github_team_repository" "this" {
  for_each   = { for team in var.teams : team.team_id => team }
  repository = github_repository.this.name
  team_id    = each.value.team_id
  permission = each.value.permission
}

# Does not work due a bug. Temporarily disabled.
# https://github.com/integrations/terraform-provider-github/issues/2477
# resource "github_repository_tag_protection" "this" {
#   for_each            = { for idx, protection in var.tag_protections : idx => protection }
#   repository          = github_repository.this.name
#   pattern             = each.value.pattern
#   allows_force_pushes = each.value.allow_force
#   allows_deletions    = each.value.allow_deletions
# }

resource "github_repository_custom_property" "this" {
  for_each       = { for prop in var.custom_properties : prop.property_name => prop }
  repository     = github_repository.this.name
  property_name  = each.key
  property_value = [each.value.property_value]
  property_type  = each.value.property_type
}

# Then enable Dependabot security updates
resource "github_repository_dependabot_security_updates" "this" {
  count      = var.enable_dependabot_security_updates ? 1 : 0
  repository = github_repository.this.name
  enabled    = true
}

# Manage topics separately with github_repository_topics if use_repository_topics_resource is true
# Otherwise topics are managed by the github_repository resource
resource "github_repository_topics" "this" {
  count      = var.topics != [] ? 1 : 0
  repository = github_repository.this.name
  topics     = var.topics
}

# Create webhooks for the repository
resource "github_repository_webhook" "this" {
  for_each = { for idx, webhook in var.webhooks : idx => webhook }

  repository = github_repository.this.name

  configuration {
    url          = each.value.url
    content_type = each.value.content_type
    secret       = each.value.secret
    insecure_ssl = each.value.insecure_ssl
  }

  active = each.value.active
  events = each.value.events
}

# Add deploy keys to the repository
resource "github_repository_deploy_key" "this" {
  for_each = { for idx, key in var.deploy_keys : idx => key }

  repository = github_repository.this.name
  title      = each.value.title
  key        = each.value.key
  read_only  = each.value.read_only
}

resource "github_actions_secret" "this" {
  for_each        = { for k, v in var.github_actions_secrets : v.name => v }
  repository      = github_repository.this.name
  secret_name     = each.key
  plaintext_value = each.value.value
}

resource "github_repository_environment" "this" {
  for_each    = { for env in var.environments : env.name => env }
  environment = each.key
  repository  = github_repository.this.name

  wait_timer          = try(each.value.wait_timer, null)
  can_admins_bypass   = try(each.value.can_admins_bypass, null)
  prevent_self_review = try(each.value.prevent_self_review, null)


  dynamic "deployment_branch_policy" {
    for_each = each.value.protected == true ? [each.value.protected] : []
    content {
      protected_branches     = false //  Ignoring this setting.  Just the fact that a branch is protected is not a green light for deployment to this environment.
      custom_branch_policies = true  // This means that the branch allows attaching github_repository_environment_deployment_policy. Yes, weird.  https://stackoverflow.com/questions/76653139/having-issue-with-environment-deployment-branches-on-github-using-terraform 
    }
  }


  dynamic "reviewers" {
    for_each = each.value.reviewers != null ? [each.value.reviewers] : []
    content {
      teams = reviewers.value.teams
      users = reviewers.value.users
    }
  }
}

resource "github_repository_environment_deployment_policy" "this" {
  for_each = {
    for env in var.environments : env.name => env
    if env.protected == true
  }

  repository     = github_repository.this.name
  environment    = each.key
  branch_pattern = each.key

  depends_on = [github_repository_environment.this]
}

resource "github_actions_environment_variable" "this" {
  for_each = {
    for pair in flatten([
      for environment in var.environments : [
        for variable in environment.variables : {
          environment = environment.name
          name        = variable.name
          value       = variable.value
        }
      ]
    ]) : "${pair.environment}.${pair.name}" => pair
  }

  repository    = github_repository.this.name
  environment   = each.value.environment
  variable_name = each.value.name
  value         = each.value.value

  depends_on = [github_repository_environment.this]
}

resource "github_actions_environment_secret" "this" {
  for_each = {
    for pair in flatten([
      for environment in var.environments : [
        for secret in environment.secrets : {
          environment = environment.name
          name        = secret.name
          value       = secret.value
        }
      ]
    ]) : "${pair.environment}.${pair.name}" => pair
  }

  repository      = github_repository.this.name
  environment     = each.value.environment
  secret_name     = each.value.name
  plaintext_value = each.value.value

  depends_on = [github_repository_environment.this]
}

resource "github_repository_file" "this" {
  for_each = var.github_repository_files

  repository                      = github_repository.this.name
  file                            = each.key
  content                         = each.value.content
  branch                          = each.value.branch
  commit_message                  = each.value.commit_message
  commit_author                   = each.value.commit_author
  commit_email                    = each.value.commit_email
  overwrite_on_create             = each.value.overwrite_on_create
  autocreate_branch               = each.value.autocreate_branch
  autocreate_branch_source_branch = coalesce(each.value.autocreate_branch_source_branch, github_branch_default.this[0].branch) # Uses default branch if not set
  autocreate_branch_source_sha    = each.value.autocreate_branch_source_sha
}

resource "github_issue_label" "this" {
  for_each = { for label in var.issue_label : label.name => label }

  repository  = github_repository.this.name
  name        = each.value.name
  color       = each.value.color
  description = each.value.description
}

resource "github_repository_autolink_reference" "this" {
  for_each = { for reference in var.autolink_references : reference.key_prefix => reference }

  repository          = github_repository.this.name
  key_prefix          = each.value.key_prefix
  target_url_template = each.value.target_url_template
  is_alphanumeric     = each.value.is_alphanumeric
}

resource "github_actions_repository_permissions" "this" {
  count = var.github_actions_repository_permissions != null ? 1 : 0

  repository = github_repository.this.name

  allowed_actions = var.github_actions_repository_permissions.allowed_actions
  enabled         = var.github_actions_repository_permissions.enabled

  dynamic "allowed_actions_config" {
    for_each = var.github_actions_repository_permissions.allowed_actions_config != null ? [var.github_actions_repository_permissions.allowed_actions_config] : []
    content {
      github_owned_allowed = try(allowed_actions_config.value.github_owned_allowed, null)
      patterns_allowed     = try(allowed_actions_config.value.patterns_allowed, [])
      verified_allowed     = try(allowed_actions_config.value.verified_allowed, null)
    }
  }
}



# 410 Projects (classic) has been deprecated in favor of the new Projects experience. []
# resource "github_repository_project" "this" {
#   for_each = { for project in var.projects : project.name => project }

#   name       = each.value.name
#   repository = github_repository.this.name
#   body       = each.value.body
# }



# resource "github_repository_ruleset" "this" {
#   repository  = github_repository.this.name
#   name        = var.ruelset.name
#   target      = var.target
#   enforcement = var.enforcement

#   dynamic "conditions" {
#     for_each = length(var.include_ref_name) > 0 || length(var.exclude_ref_name) > 0 ? [1] : []
#     content {
#       ref_name {
#         include = var.include_ref_name
#         exclude = var.exclude_ref_name
#       }
#     }
#   }

#   dynamic "bypass_actors" {
#     for_each = var.bypass_actors == null ? [] : [var.bypass_actors]
#     content {
#       actor_id    = bypass_actors.value.actor_id
#       actor_type  = bypass_actors.value.actor_type
#       bypass_mode = bypass_actors.value.bypass_mode
#       }
#     }
#   rules {
#     creation = var.creation
#     deletion = var.deletion
#     update = var.update
#     non_fast_forward = var.non_fast_forward
#     dynamic "pull_request" {
#       for_each = var.pull_request_rules != null ? [1] : []
#       content {
#         dismiss_stale_reviews_on_push   = var.pull_request_rules.dismiss_stale_reviews
#         require_code_owner_review       = var.pull_request_rules.require_code_owner_reviews
#         required_approving_review_count = var.pull_request_rules.required_approving_review_count
#       }
#     }
#   }
# }


# resource "github_repository_ruleset" "this" {
#   for_each = toset(var.ruleset)
#   repository  = github_repository.this.name
#   name        = each.value.name
#   target      = each.value.target
#   enforcement = each.value.enforcement

#   conditions {
#     ref_name {
#       include = ["~ALL"]
#       exclude = []
#     }
#   }

#   bypass_actors {
#     actor_id    = 13473
#     actor_type  = "Integration"
#     bypass_mode = "always"
#   }

#   rules {
#     creation                = true
#     update                  = true
#     deletion                = true
#     required_linear_history = true
#     required_signatures     = true

#     required_deployments {
#       required_deployment_environments = ["test"]
#     }


#   }
# }
