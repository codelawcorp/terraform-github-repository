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
