# Outputs for github_repository attributes
output "name" {
  description = "The name of the repository"
  value       = github_repository.this.name
}

output "pages_url" {
  description = "The URL of the GitHub Pages site"
  value       = try(github_repository.this.pages[0].html_url, null)
}

output "description" {
  description = "The description of the repository"
  value       = github_repository.this.description
}

output "visibility" {
  description = "The visibility of the repository"
  value       = github_repository.this.visibility
}

output "homepage_url" {
  description = "The homepage URL of the repository"
  value       = github_repository.this.homepage_url
}

output "has_issues" {
  description = "Whether the repository has issues enabled"
  value       = github_repository.this.has_issues
}

output "has_projects" {
  description = "Whether the repository has projects enabled"
  value       = github_repository.this.has_projects
}

output "has_wiki" {
  description = "Whether the repository has wiki enabled"
  value       = github_repository.this.has_wiki
}

output "has_discussions" {
  description = "Whether the repository has discussions enabled"
  value       = github_repository.this.has_discussions
}

output "has_downloads" {
  description = "Whether the repository has downloads enabled"
  value       = github_repository.this.has_downloads
}

output "allow_merge_commit" {
  description = "Whether merge commits are allowed"
  value       = github_repository.this.allow_merge_commit
}

output "allow_auto_merge" {
  description = "Whether auto merge is allowed"
  value       = github_repository.this.allow_auto_merge
}

output "allow_squash_merge" {
  description = "Whether squash merge is allowed"
  value       = github_repository.this.allow_squash_merge
}

output "allow_rebase_merge" {
  description = "Whether rebase merge is allowed"
  value       = github_repository.this.allow_rebase_merge
}

output "delete_branch_on_merge" {
  description = "Whether to delete branch on merge"
  value       = github_repository.this.delete_branch_on_merge
}

output "is_template" {
  description = "Whether the repository is a template"
  value       = github_repository.this.is_template
}

output "archived" {
  description = "Whether the repository is archived"
  value       = github_repository.this.archived
}

output "web_commit_signoff_required" {
  description = "Whether web commit signoff is required"
  value       = github_repository.this.web_commit_signoff_required
}

output "vulnerability_alerts" {
  description = "Whether vulnerability alerts are enabled"
  value       = github_repository.this.vulnerability_alerts
}

# Outputs for other resources
output "github_actions_variables" {
  description = "GitHub Actions variables for the repository"
  value       = github_actions_variable.this
}

output "github_branch_default" {
  description = "Default branch configuration"
  value       = github_branch_default.this
}

output "github_branches" {
  description = "Repository branches"
  value       = github_branch.this
}

output "github_branch_protections" {
  description = "Branch protection rules"
  value       = github_branch_protection.this
}

output "github_repository_collaborators" {
  description = "Repository collaborators"
  value       = github_repository_collaborator.this
}

output "github_team_repositories" {
  description = "Team repository permissions"
  value       = github_team_repository.this
}

output "github_repository_custom_properties" {
  description = "Repository custom properties"
  value       = github_repository_custom_property.this
}

output "github_repository_dependabot_security_updates" {
  description = "Dependabot security updates configuration"
  value       = github_repository_dependabot_security_updates.this
}

output "github_repository_topics" {
  description = "Repository topics"
  value       = github_repository_topics.this
}

output "github_repository_webhooks" {
  description = "Repository webhooks"
  value       = github_repository_webhook.this
  sensitive   = true
}

output "github_repository_deploy_keys" {
  description = "Repository deploy keys"
  value       = github_repository_deploy_key.this
  sensitive   = true
}

output "github_actions_secrets" {
  description = "GitHub Actions secrets"
  value       = github_actions_secret.this
  sensitive   = true
}

output "github_repository_environments" {
  description = "Repository environments"
  value       = github_repository_environment.this
}

output "github_repository_environment_deployment_policies" {
  description = "Environment deployment policies"
  value       = github_repository_environment_deployment_policy.this
}

output "github_actions_environment_variables" {
  description = "Environment variables for GitHub Actions"
  value       = github_actions_environment_variable.this
}

output "github_actions_environment_secrets" {
  description = "Environment secrets for GitHub Actions"
  value       = github_actions_environment_secret.this
  sensitive   = true
}

output "github_repository_files" {
  description = "Repository files"
  value       = github_repository_file.this
}

output "github_issue_labels" {
  description = "Issue labels"
  value       = github_issue_label.this
}

output "github_repository_autolink_references" {
  description = "Repository autolink references"
  value       = github_repository_autolink_reference.this
}

# output "github_repository_projects" {
#   description = "Repository projects"
#   value       = github_repository_project.this
# }
