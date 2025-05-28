output "repository_name" {
  description = "The name of the repository"
  value       = module.github_repository_complete.name
}

output "repository_visibility" {
  description = "The visibility of the repository"
  value       = module.github_repository_complete.visibility
}

output "repository_has_issues" {
  description = "Whether the repository has issues enabled"
  value       = module.github_repository_complete.has_issues
}

output "repository_has_wiki" {
  description = "Whether the repository has wiki enabled"
  value       = module.github_repository_complete.has_wiki
}

output "repository_description" {
  description = "The description of the repository"
  value       = module.github_repository_complete.description
}

output "repository_topics" {
  description = "The topics of the repository"
  value       = module.github_repository_complete.github_repository_topics
}

output "repository_environments" {
  description = "The environments of the repository"
  value       = module.github_repository_complete.github_repository_environments
}

output "repository_webhooks" {
  description = "The webhooks of the repository"
  value       = module.github_repository_complete.github_repository_webhooks
  sensitive   = true
}

output "repository_files" {
  description = "The files in the repository"
  value       = module.github_repository_complete.github_repository_files
}
