# Outputs for github_repository attributes
output "repository" {
  description = "All available outputs github_repository.this"
  value       = github_repository.this
}
# Outputs for other resources
output "actions_variables" {
  description = "All available outputs from github_actions_variable.this"
  value       = github_actions_variable.this
}

output "branch_default" {
  description = "All available outputs from github_branch_default.this"
  value       = try(github_branch_default.this[0].branch, data.github_repository.this.default_branch, null)
}

output "branches" {
  description = "All available outputs from github_branch.this"
  value       = github_branch.this
}

output "branch_protections" {
  description = "All available outputs from github_branch_protection.this"
  value       = github_branch_protection.this
}

output "repository_collaborators" {
  description = "All available outputs from github_repository_collaborator.this"
  value       = github_repository_collaborator.this
}

output "team_repositories" {
  description = "All available outputs from github_team_repository.this"
  value       = github_team_repository.this
}

output "repository_custom_properties" {
  description = "All available outputs from github_repository_custom_property.this"
  value       = github_repository_custom_property.this
}

output "repository_dependabot_security_updates" {
  description = "All available outputs from github_repository_dependabot_security_updates.this"
  value       = github_repository_dependabot_security_updates.this
}

output "repository_topics" {
  description = "All available outputs from github_repository_topics.this"
  value       = github_repository_topics.this
}

output "repository_webhooks" {
  description = "All available outputs from github_repository_webhook.this"
  value       = github_repository_webhook.this
  sensitive   = true
}

output "repository_deploy_keys" {
  description = "All available outputs from github_repository_deploy_key.this"
  value       = github_repository_deploy_key.this
  sensitive   = true
}

output "actions_secrets" {
  description = "All available outputs from github_actions_secret.this"
  value       = github_actions_secret.this
  sensitive   = true
}

output "repository_environments" {
  description = "All available outputs from github_repository_environment.this"
  value       = github_repository_environment.this
}

output "repository_environment_deployment_policies" {
  description = "All available outputs from github_repository_environment_deployment_policy.this"
  value       = github_repository_environment_deployment_policy.this
}

output "actions_environment_variables" {
  description = "All available outputs from github_actions_environment_variable.this"
  value       = github_actions_environment_variable.this
}

output "actions_environment_secrets" {
  description = "All available outputs from github_actions_environment_secret.this"
  value       = github_actions_environment_secret.this
  sensitive   = true
}

output "repository_files" {
  description = "All available outputs from github_repository_file.this"
  value       = github_repository_file.this
}

output "issue_labels" {
  description = "All available outputs from github_issue_label.this"
  value       = github_issue_label.this
}

output "repository_autolink_references" {
  description = "All available outputs from github_repository_autolink_reference.this"
  value       = github_repository_autolink_reference.this
}

output "actions_repository_permissions" {
  description = "All available outputs from github_actions_repository_permissions.this"
  value       = github_actions_repository_permissions.this
}

# output "repository_projects" {
#   description = "All available outputs from github_repository_project.this"
#   value       = github_repository_project.this
# }
