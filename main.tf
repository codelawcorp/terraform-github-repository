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

  allow_merge_commit     = var.allow_merge_commit
  allow_squash_merge     = var.allow_squash_merge
  allow_rebase_merge     = var.allow_rebase_merge
  delete_branch_on_merge = var.delete_branch_on_merge

  is_template = var.is_template
  archived    = var.archived

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
  repository = github_repository.this.name
  branch     = var.default_branch
}

resource "github_branch" "this" {
  for_each = { for branch in var.branches : branch.name => branch }

  repository    = github_repository.this.name
  branch        = each.value.name
  source_branch = each.value.source_branch
  source_sha    = each.value.source_sha
}

resource "github_branch_protection" "this" {
  for_each = { for branch in var.branches : branch.name => branch if branch.enforce_admins != null || branch.required_status_checks != null || branch.required_pull_request_reviews != null || branch.restrictions != null }

  repository_id  = github_repository.this.node_id
  pattern        = each.value.name
  enforce_admins = each.value.enforce_admins

  dynamic "required_status_checks" {
    for_each = each.value.required_status_checks != null ? [each.value.required_status_checks] : []
    content {
      strict   = required_status_checks.value.strict
      contexts = required_status_checks.value.contexts
    }
  }

  dynamic "required_pull_request_reviews" {
    for_each = each.value.required_pull_request_reviews != null ? [each.value.required_pull_request_reviews] : []
    content {
      dismiss_stale_reviews           = required_pull_request_reviews.value.dismiss_stale_reviews
      restrict_dismissals             = required_pull_request_reviews.value.restrict_dismissals
      dismissal_restrictions          = required_pull_request_reviews.value.dismissal_restrictions
      require_code_owner_reviews      = required_pull_request_reviews.value.require_code_owner_reviews
      required_approving_review_count = required_pull_request_reviews.value.required_approving_review_count
    }
  }

  #   dynamic "restrictions" {
  #     for_each = each.value.restrictions != null ? [each.value.restrictions] : []
  #     content {
  #       users = restrictions.value.users
  #       teams = restrictions.value.teams
  #       apps  = restrictions.value.apps
  #     }
  #   }
}

