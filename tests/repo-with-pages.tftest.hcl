# # Define random suffix for repository names to avoid conflicts
# run "setup_tests" {
#   module {
#     source = "./tests/setup"
#   }
# }

variables {
  name = "tf-test-repo-pages"
  pages = {
    build_type = "workflow"
    source = {
      branch = "main"
      path   = "/"
    }
  }
}

# provider "github" {
#   owner = "codelawcorp"
# }

run "repo_without_pages" {


  variables {
    name               = var.name
    description        = "Test repository without pages"
    visibility         = "private"
    auto_init          = true
    pages              = null
    archive_on_destroy = false
  }


  # Assert that the repository is created successfully
  assert {
    condition     = output.name != ""
    error_message = "Repository was not created successfully"
  }
}

run "repo_with_pages" {
  variables {
    name               = var.name
    description        = "Test repository with pages"
    visibility         = "private"
    auto_init          = true
    pages              = var.pages
    archive_on_destroy = false
  }

  # Assert that the repository is created successfully
  assert {
    condition     = output.name != ""
    error_message = "Repository was not created successfully"
  }
}

