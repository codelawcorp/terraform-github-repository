module "github_repository" {
  source = "../"

  name        = "test-example-repo-23"
  description = "An example repository created using Terraform"
  visibility  = "private"

  # Optional settings
  homepage_url = "https://example.com"
  topics       = ["terraform", "github", "example"]

  # Feature flags
  has_issues    = true
  has_projects  = true
  has_wiki      = true
  has_downloads = true

  # Merge settings
  allow_merge_commit     = true
  allow_squash_merge     = true
  allow_rebase_merge     = true
  delete_branch_on_merge = true

  # Repository settings
  is_template    = false
  default_branch = "prod"
  archived       = false

  # Template configuration (if using a template repository)
  template = {
    owner                = "codelawcorp"
    repository           = "template"
    include_all_branches = true
  }

  branches = [
    {
      name = "gh-pages" # TODO / create pages branch if this is specified
    }
  ]

  #   # GitHub Pages configuration (optional)
  pages = {
    source = {
      branch = "gh-pages" 
      path   = "/"
    }
  }

  # Security and analysis features (optional)
  #   security_and_analysis = {
  #     advanced_security = {
  #       status = "enabled"
  #     }
  #     secret_scanning = {
  #       status = "enabled"
  #     }
  #     secret_scanning_push_protection = {
  #       status = "enabled"
  #     }
  #   }
  archive_on_destroy = false

  environments = [
    {
      name = "prod"
      deployment_branch_policy = {
        protected_branches     = true
        custom_branch_policies = false
      }
      reviewers = {
        users = []
        teams = []
      }
    },
    {
      name = "stg"
      reviewers = {
        users = []
      }
    }
  ]
}


module "another_repo" {
  source             = "../"
  name               = "test-another-repo"
  archive_on_destroy = false
  auto_init          = true

  github_actions_variables = [
    {
      name  = "TEST_VARIABLE"
      value = "test-value"
    }
  ]

  environments = [
    {
      name = "prod"
      deployment_branch_policy = {
        protected_branches     = true
        custom_branch_policies = false
      }
      reviewers = {
        users = []
        teams = []
      }
    },
    {
      name = "stg"
      reviewers = {
        users = []
      }
    }
  ]
}

