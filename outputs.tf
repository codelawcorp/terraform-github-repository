# Outputs for github_repository attributes
output "repository" {
  description = "The full repository details"
  value       = github_repository.this
}
# Outputs for other resources
output "actions_variables" {
  description = "GitHub Actions variables for the repository"
  value       = github_actions_variable.this
}

output "branch_default" {
  description = "Default branch configuration"
  value       = github_branch_default.this
}

output "branches" {
  description = "Repository branches"
  value       = github_branch.this
}

output "branch_protections" {
  description = "Branch protection rules"
  value       = github_branch_protection.this
}

output "repository_collaborators" {
  description = "Repository collaborators"
  value       = github_repository_collaborator.this
}

output "team_repositories" {
  description = "Team repository permissions"
  value       = github_team_repository.this
}

output "repository_custom_properties" {
  description = "Repository custom properties"
  value       = github_repository_custom_property.this
}

output "repository_dependabot_security_updates" {
  description = "Dependabot security updates configuration"
  value       = github_repository_dependabot_security_updates.this
}

output "repository_topics" {
  description = "Repository topics"
  value       = github_repository_topics.this
}

output "repository_webhooks" {
  description = "Repository webhooks"
  value       = github_repository_webhook.this
  sensitive   = true
}

output "repository_deploy_keys" {
  description = "Repository deploy keys"
  value       = github_repository_deploy_key.this
  sensitive   = true
}

output "actions_secrets" {
  description = "GitHub Actions secrets"
  value       = github_actions_secret.this
  sensitive   = true
}

output "repository_environments" {
  description = "Repository environments"
  value       = github_repository_environment.this
}

output "repository_environment_deployment_policies" {
  description = "Environment deployment policies"
  value       = github_repository_environment_deployment_policy.this
}

output "actions_environment_variables" {
  description = "Environment variables for GitHub Actions"
  value       = github_actions_environment_variable.this
}

output "actions_environment_secrets" {
  description = "Environment secrets for GitHub Actions"
  value       = github_actions_environment_secret.this
  sensitive   = true
}

output "repository_files" {
  description = "Repository files"
  value       = github_repository_file.this
}

output "issue_labels" {
  description = "Issue labels"
  value       = github_issue_label.this
}

output "repository_autolink_references" {
  description = "Repository autolink references"
  value       = github_repository_autolink_reference.this
}

output "actions_repository_permissions" {
  description = "GitHub Actions permissions configuration"
  value       = github_actions_repository_permissions.this
}

# output "repository_projects" {
#   description = "Repository projects"
#   value       = github_repository_project.this
# }
