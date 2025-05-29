module "github_repository_minimal" {
  source = "../../"
  name   = "test-${basename(path.root)}"

  default_branch = "main"

  archive_on_destroy = false # Not a critical repo
}

