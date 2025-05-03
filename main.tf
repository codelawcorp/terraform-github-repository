output "repo_debug" {
  value = github_repository.this
}

resource "github_repository" "this" {
  name        = var.name
  description = var.description
  visibility  = var.visibility

  homepage_url = var.homepage_url
  topics       = var.topics

  has_issues    = var.has_issues
  has_projects  = var.has_projects
  has_wiki      = var.has_wiki
  has_downloads = var.has_downloads

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
  auto_init                   = var.template != null ? false : var.auto_init
  gitignore_template          = var.gitignore_template
  license_template            = var.license_template
  archive_on_destroy          = var.archive_on_destroy

  dynamic "template" {
    for_each = var.template != null ? [var.template] : []
    content {
      owner                = template.value.owner
      repository           = template.value.repository
      include_all_branches = template.value.include_all_branches
    }
  }

  dynamic "pages" {
    for_each = var.pages != null ? [var.pages] : []
    content {
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

resource "github_branch_default" "this" {
  count      = var.auto_init == false || length(var.branches) > 0 ? 1 : 0
  repository = github_repository.this.name
  branch     = var.default_branch
}

resource "github_branch" "this" {
  for_each = { for branch in var.branches : branch.name => branch }

  repository    = github_repository.this.name
  branch        = each.value.name
  source_branch = coalesce(each.value.source_branch, github_repository.this.default_branch)
  source_sha    = each.value.source_sha

  depends_on = [github_branch_default.this]

}

resource "github_branch_protection" "this" {
  for_each = { for branch in var.branches : branch.name => branch if branch.protection != null }

  repository_id  = github_repository.this.node_id
  pattern        = each.value.name
  enforce_admins = coalesce(each.value.protection.enforce_admins, false)

  dynamic "required_status_checks" {
    for_each = each.value.protection.required_status_checks != null ? [each.value.protection.required_status_checks] : []
    content {
      strict   = coalesce(required_status_checks.value.strict, false)
      contexts = coalesce(required_status_checks.value.contexts, [])
    }
  }

  dynamic "required_pull_request_reviews" {
    for_each = each.value.protection.required_pull_request_reviews != null ? [each.value.protection.required_pull_request_reviews] : []
    content {
      dismiss_stale_reviews           = coalesce(required_pull_request_reviews.value.dismiss_stale_reviews, false)
      restrict_dismissals             = coalesce(required_pull_request_reviews.value.restrict_dismissals, false)
      dismissal_restrictions          = coalesce(required_pull_request_reviews.value.dismissal_restrictions, [])
      require_code_owner_reviews      = coalesce(required_pull_request_reviews.value.require_code_owner_reviews, false)
      required_approving_review_count = coalesce(required_pull_request_reviews.value.required_approving_review_count, 1)
    }
  }
}

resource "github_actions_variable" "this" {
  for_each      = { for k, v in var.github_actions_variables : v.name => v }
  repository    = github_repository.this.name
  variable_name = each.key
  value         = each.value.value
}

resource "github_repository_collaborators" "this" { # instead of github_repository_collaborator or github_team_repository 
  repository = github_repository.this.name
  dynamic "user" {
    for_each = var.users
    content {
      username   = user.value.username
      permission = user.value.permission
    }
  }

  dynamic "team" {
    for_each = var.teams
    content {
      team_id    = team.value.team_id
      permission = team.value.permission
    }
  }
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


  deployment_branch_policy {
    protected_branches     = false                //  Ignoring this setting. Some branch protection is not a green light for deployment.
    custom_branch_policies = each.value.protected // This means that the branch allows ataching github_repository_environment_deployment_policy. Yes, weird.  https://stackoverflow.com/questions/76653139/having-issue-with-environment-deployment-branches-on-github-using-terraform 
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

