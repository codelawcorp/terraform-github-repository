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

  # #   # GitHub Pages configuration (optional)
  # pages = { // TODO / pages branch must exist at applytime / chicken-egg problem
  #   source = {
  #     branch = "gh-pages"
  #     path   = "/"
  #   }
  # }

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
      reviewers = {
        users = []
        teams = []
      }
      protected = true
      # tag_pattern   = "v*"
      variables = [
        {
          name  = "API_URL"
          value = "https://api.example.com/prod"
        },
        {
          name  = "DEBUG_MODE"
          value = "false"
        }
      ]
      secrets = [
        {
          name  = "DEPLOY_TOKEN"
          value = "secret-token-value"
        },
        {
          name  = "DATABASE_PASSWORD"
          value = "db-password-value"
        }
      ]
    },
    {
      name = "stg"
      reviewers = {
        users = []
      }
      protected = true
      # tag_pattern   = "stg-v*"
      variables = [
        {
          name  = "API_URL"
          value = "https://api.example.com/staging"
        },
        {
          name  = "DEBUG_MODE"
          value = "true"
        }
      ]
    }
  ]

  github_actions_variables = [
    {
      name  = "CI_ENABLED"
      value = "true"
    },
    {
      name  = "DEPLOY_ENVIRONMENT"
      value = "production"
    }
  ]

  # This also automatically enables vulnerability_alerts
  enable_dependabot_security_updates = true

  # Use the dedicated github_repository_topics resource for topic management
  use_repository_topics_resource = true

  # Configure webhooks for the repository
  webhooks = [
    {
      url          = "https://jenkins.example.com/github-webhook/"
      content_type = "json"
      events       = ["push", "pull_request"]
    },
    {
      url          = "https://ci.example.com/webhook"
      content_type = "form"
      secret       = "secureSecret123"
      events       = ["release"]
    }
  ]



  # Tag protections disabled temporarily due to bug
  # https://github.com/integrations/terraform-provider-github/issues/2477
  # tag_protections = [
  #   {
  #     pattern = "v[0-9]+.[0-9]+.[0-9]+"  # Protect semantic versioning tags (default)
  #   },
  #   {
  #     pattern = "release-*"  # Also protect release tags
  #     allow_deletions = true  # But allow deletions for release tags
  #   }
  # ]


  users = [
    # {
    #   username   = "example-user"
    #   permission = "push"
    # }
  ]

  teams = [
    # {
    #   team_id    = "admin-team"
    #   permission = "admin"
    # }
  ]

  # Add GitHub repository files
  github_repository_files = {
    "README.md" = {
      content        = "# Example Repository\nThis is an example repository managed by Terraform."
      branch         = "prod"
      commit_message = "Add README.md"
      commit_author  = "Terraform Bot"
      commit_email   = "test@test.com"

      overwrite_on_create = true
    }
    "test.md" = {
      content = "# A test file."
      branch  = "random-branch"
      # commit_message      = "Add README.md"
      # commit_author       = "Terraform Bot"
      # commit_email        = "test@test.com"
      # overwrite_on_create = true
    }
    "test-default-branch.md" = {
      content = "# A test file."
      # branch              = "random-branch"
      # commit_message      = "Add README.md"
      # commit_author       = "Terraform Bot"
      # commit_email        = "test@test.com"
      # overwrite_on_create = true
    }
  }

  # Add issue labels
  issue_label = [
    {
      name        = "critical"
      color       = "ff0000"
      description = "Critical issues that need immediate attention"
    },
    {
      name        = "feature-request"
      color       = "00ff00"
      description = "Suggestions for new features"
    }
  ]
  # Create an autolink reference
  autolink_references = [
    {
      key_prefix          = "PROJECT-"
      target_url_template = "https://example.com/view/PROJECT-<num>"
      is_alphanumeric     = false # Default is true"
    },
    {
      prefix              = "PR-"
      target_url_template = "https://example.com/pull/PR-<num>"
      is_alphanumeric     = false # Default is true
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

  github_actions_secrets = [
    {
      name  = "API_KEY"
      value = "some-api-key-value"
    },
    {
      name  = "DEPLOYMENT_TOKEN"
      value = "some-deployment-token"
    }
  ]

  # Explicitly disable Dependabot security updates
  enable_dependabot_security_updates = false

  # But still enable vulnerability alerts
  vulnerability_alerts = true

  # Use built-in topics on the repository resource (default)
  use_repository_topics_resource = false

  # Configure a simple webhook
  webhooks = [
    {
      url          = "https://notify.example.com/github"
      content_type = "json"
      events       = ["push"]
    }
  ]

  # Add a read-only deploy key
  deploy_keys = [
    {
      title = "Read-only CI Key"
      # this is how to generate the key // ssh-keygen -f test
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKB/4GlDREJaArBSKACPHpczJGrw2SoDRE4y5MyBN+7+ maksymonyshchenko@Maksyms-MacBook-Pro-3.local"
      # read_only defaults to true
    }
  ]

  # Tag protections disabled temporarily due to bug
  # https://github.com/integrations/terraform-provider-github/issues/2477
  # tag_protections = [
  #   {
  #     pattern = "v[0-9]+.[0-9]+.[0-9]+"  # Default semantic versioning pattern
  #   }
  # ]

  custom_properties = [
    {
      property_name  = "test"
      property_value = "active"
    },
  ]

  users = [
    # {
    #   username   = "contributor-user"
    #   permission = "pull"
    # },
    # {
    #   username   = "maintainer-user"
    #   permission = "maintain"
    # }
  ]

  teams = [
    # {
    #   team_id       = "admin-team"
    #   permission = "admin"
    # }
  ]

  environments = [
    {
      name = "prod"
      reviewers = {
        users = []
        teams = []
      }
      protected = true
      # tag_pattern   = "v*"
      variables = [
        {
          name  = "ENVIRONMENT"
          value = "production"
        }
      ]
      secrets = [
        {
          name  = "PRODUCTION_API_KEY"
          value = "your-sensitive-api-key"
        }
      ]
    },
    {
      name = "stg"
      reviewers = {
        users = []
      }
      protected = true
      # tag_pattern   = "stg-v*"
      variables = [
        {
          name  = "test"
          value = "some-value"
        }
      ]
    }
  ]
}
