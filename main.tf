resource "github_repository" "this" {
  name        = var.name
  description = var.description

  visibility = var.visibility

  template {
    owner                = var.template.owner
    repository           = var.template.repository
    include_all_branches = var.template.include_all_branches
  }
}