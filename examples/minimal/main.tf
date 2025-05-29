module "github_repository_minimal" {
  source = "../../"
  name   = "test-${basename(path.root)}"


  archive_on_destroy = false # Not a critical repo
}

