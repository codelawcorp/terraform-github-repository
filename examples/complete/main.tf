module "github_repository_complete" {
  source = "../../"

  name        = "test-${basename(path.root)}" # Any repository name.
  description = "An example repository created using Terraform"
  visibility  = "public"

  default_branch = "prod"

  archive_on_destroy = false
  archived           = false
  auto_init          = false # Deprecated by this module. Might be removed in the future.
  is_template        = false

  homepage_url = "https://example.com"
  topics       = ["terraform", "github", "example"]

  has_issues      = true
  has_projects    = true
  has_wiki        = true
  has_downloads   = true
  has_discussions = true

  # Merge settings
  allow_auto_merge       = true
  allow_merge_commit     = true
  allow_squash_merge     = true
  allow_rebase_merge     = true
  delete_branch_on_merge = true
  merge_commit_message   = "BLANK"
  merge_commit_title     = "PR_TITLE"



  # Template configuration (if using a template repository)
  template = {
    owner                = "codelawcorp"
    repository           = "template"
    include_all_branches = true
  }

  branches = [
    {
      name = "gh-pages"
    },
    {
      name = "prod" # Try test without prod
      protection = {
        enforce_admins                  = true
        required_linear_history         = true
        require_conversation_resolution = true
        require_signed_commits          = true
        allows_deletions                = false
        allows_force_pushes             = false
        force_push_bypassers            = ["/magzim21"]
        lock_branch                     = true
        required_status_checks = {
          strict   = true
          contexts = ["ci/test", "ci/lint"]
        }
        required_pull_request_reviews = {
          dismiss_stale_reviews           = true
          restrict_dismissals             = true
          dismissal_restrictions          = ["/magzim21"]
          pull_request_bypassers          = ["/magzim21"]
          require_code_owner_reviews      = true
          required_approving_review_count = 2
          require_last_push_approval      = true
        }
        restrict_pushes = {
          blocks_creations = true
          push_allowances  = ["/magzim21"]
        }
      }
    },
    {
      name = "stg"
    }
  ]

  custom_properties = [
    {
      property_name  = "test"
      property_value = "test"
      property_type  = "string"
    }
  ]

  deploy_keys = [
    {
      title = "Some CI Key"
      # this is how to generate the key // ssh-keygen -f test
      key       = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII0kKdZ/vUygOfzycmhqe4JoX6AJFl2XVOXyvbuP9L/0 some-metadata"
      read_only = false
    }
  ]

  # #   # GitHub Pages configuration (optional)
  # pages = { // GitHub provider issue: pages branch must exist at applytime / chicken-egg problem
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

  environments = [
    {
      name = "prod"
      reviewers = {
        users = []
        teams = []
      }
      protected           = true
      wait_timer          = 10
      can_admins_bypass   = true
      prevent_self_review = true
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
      name  = "TEST_VAR"
      value = "true"
    }
  ]

  github_actions_secrets = [
    {
      name  = "DEPLOY_TOKEN"
      value = "secret-token-value"
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
      branch         = "stg" # If branch does not exist, it will be created. Configure signed commits if require_signed_commits is true on this branch. 
      commit_message = "Add README.md"
      commit_author  = "Terraform Bot"
      commit_email   = "test@test.com"

      overwrite_on_create = true
    }
  }

  # Add issue labels
  issue_label = [
    {
      name        = "critical"
      color       = "ff0000"
      description = "Critical issues that need immediate attention"
    }
  ]
  # Create an autolink reference
  autolink_references = [
    {
      key_prefix          = "PROJECT-"
      target_url_template = "https://example.com/view/PROJECT-<num>"
      is_alphanumeric     = false # Default is true"
    }
  ]

  gitignore_template = "Python"
  license_template   = "mit"


  # 410 Projects (classic) has been deprecated in favor of the new Projects experience. []
  # Add projects
  # projects = [
  #   {
  #     name = "Project 1"
  #     body = "This is the first project."
  #   },
  #   {
  #     name = "Project 2"
  #     body = "This is the second project."
  #   }
  # ]
}

