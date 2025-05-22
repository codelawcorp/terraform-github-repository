module "github_repository_minimal" {
  source = "../../"
  name   = "test-example-minimal"

  archive_on_destroy = false # Not a critical repo
}

