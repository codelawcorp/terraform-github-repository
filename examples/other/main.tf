module "another_repo" {
  source = "../../"

  name               = "test-${basename(abspath(path.root))}"
  archive_on_destroy = false


  actions_variables = [
    {
      name  = "TEST_VARIABLE"
      value = "test-value"
    }
  ]

  actions_secrets = [
    {
      name  = "API_KEY"
      value = "some-api-key-value"
    },
    {
      name  = "DEPLOYMENT_TOKEN"
      value = "some-deployment-token"
    }
  ]

  allow_merge_commit = false
  allow_squash_merge = true
  allow_rebase_merge = true
  allow_auto_merge   = true


  visibility = "public"

  homepage_url = "https://registry.terraform.io/modules/codelawcorp/repository/github/latest"

  # The following are valid combinations for the squash commit title and message: PR_TITLE and PR_BODY, PR_TITLE and BLANK, PR_TITLE and COMMIT_MESSAGES, COMMIT_OR_PR_TITLE and COMMIT_MESSAGES

  delete_branch_on_merge = true

  web_commit_signoff_required = true




  template = {
    owner                = "codelawcorp"
    repository           = "template"
    include_all_branches = true
  }





  # Explicitly disable Dependabot security updates
  enable_dependabot_security_updates = false

  # But still enable vulnerability alerts
  vulnerability_alerts = true

  # GitHub Actions repository permissions
  actions_repository_permissions = {
    allowed_actions = "selected" # Options: all, local_only, selected
    enabled         = true
    allowed_actions_config = {
      github_owned_allowed = true
      patterns_allowed     = ["actions/checkout@*", "actions/setup-*@*"]
      verified_allowed     = true
    }
  }

  # Configure a simple webhook
  webhooks = [
    {
      url          = "https://notify.example.com/github"
      content_type = "json"
      events       = ["push"]
    }
  ]

  deploy_keys = [
    {
      title = "Some CI Key"
      # this is how to generate the key // ssh-keygen -f test
      key       = tls_private_key.this.public_key_openssh
      read_only = false
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

  branches = [
    {
      name = "main"
    },
    {
      name = "prod"
    },
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
        },
        {
          name  = "SOME_LONG_SECRET"
          value = "some-long-secret-value-loooooooooooooooolooooooooooooooooloooooooooooooooolooooooooooooooooloooooooooooooooolooooooooooooooooloooooooooooooooolooooooooooooooooloooooooooooooooong"
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
  rulesets = [
    {
      name        = "Comprehensive Ruleset Example"
      target      = "branch"
      enforcement = "active"

      # Conditions to specify which branches this ruleset applies to
      conditions = {
        ref_name = {
          include = ["main", "develop", "release/*"]
          exclude = ["feature/*", "draft/*"]
        }
      }

      # Bypass actors who can bypass this ruleset
      # Note: actor_id must be a valid user/team/app ID when actor_type is not OrganizationAdmin
      # bypass_actors = [
      #   {
      #     actor_id   = "12345678" # Set to actual actor ID (user/team/app ID) when needed
      #     actor_type = "Team" # Options: OrganizationAdmin, RepositoryRole, Team, Integration
      #     bypass_mode = "always" # Options: always, pull_request
      #   }
      # ]

      # All available rules
      rules = {
        # Basic ref protection rules
        creation                      = true  # Only allow users with bypass permission to create matching refs
        update                        = true  # Only allow users with bypass permission to update matching refs
        update_allows_fetch_and_merge = true  # Branch can pull changes from upstream (requires update = true)
        deletion                      = true  # Only allow users with bypass permissions to delete matching refs
        required_linear_history       = true  # Prevent merge commits from being pushed to matching branches
        required_signatures           = false # Commits pushed to matching branches must have verified signatures
        non_fast_forward              = false # Prevent non-fast-forward pushes to matching branches

        # Branch name pattern rule
        branch_name_pattern = {
          name     = "Branch Name Pattern Rule"
          operator = "starts_with" # Options: starts_with, ends_with, contains, regex
          pattern  = "main"
          negate   = false
        }

        # Commit author email pattern rule
        commit_author_email_pattern = {
          name     = "Commit Author Email Pattern"
          operator = "ends_with" # Options: starts_with, ends_with, contains, regex
          pattern  = "@company.com"
          negate   = false
        }

        # Commit message pattern rule
        commit_message_pattern = {
          name     = "Commit Message Pattern"
          operator = "regex" # Options: starts_with, ends_with, contains, regex
          pattern  = "^(feat|fix|docs|style|refactor|perf|test|chore)(\\(.+\\))?: .+"
          negate   = false
        }

        # Committer email pattern rule
        committer_email_pattern = {
          name     = "Committer Email Pattern"
          operator = "ends_with"
          pattern  = "@company.com"
          negate   = false
        }

        # Note: tag_name_pattern cannot be used with branch_name_pattern in the same ruleset
        # Use a separate ruleset with target = "tag" for tag name patterns

        # Merge queue configuration
        # Note: merge_method must match repository's allowed merge types (allow_merge_commit, allow_squash_merge, allow_rebase_merge)
        merge_queue = [
          {
            check_response_timeout_minutes    = 5
            grouping_strategy                 = "ALLGREEN" # Options: ALLGREEN, HEADGREEN
            max_entries_to_build              = 10
            max_entries_to_merge              = 3
            merge_method                      = "SQUASH" # Options: MERGE, SQUASH, REBASE (must match repository settings)
            min_entries_to_merge              = 1
            min_entries_to_merge_wait_minutes = 0
          }
        ]

        # Pull request rules
        pull_request = [
          {
            dismiss_stale_reviews_on_push     = true
            require_code_owner_review         = true
            require_last_push_approval        = true
            required_approving_review_count   = 2
            required_review_thread_resolution = true
          }
        ]

        # Required deployments (must match actual environment names defined in environments)
        required_deployments = [
          {
            required_deployment_environments = ["prod", "stg"]
          }
        ]

        # Required status checks
        required_status_checks = [
          {
            required_check = [
              {
                context        = "ci/build"
                integration_id = null
              },
              {
                context        = "ci/test"
                integration_id = null
              }
            ]
            strict_required_status_checks_policy = true
            do_not_enforce_on_create             = false
          }
        ]

        # Required code scanning
        required_code_scanning = {
          required_code_scanning_tool = {
            alerts_threshold          = "none"   # Options: none, errors, warnings, errors_and_warnings
            security_alerts_threshold = "none"   # Options: none, errors, warnings, errors_and_warnings
            tool                      = "CodeQL" # Options: CodeQL, or custom tool name
          }
        }
      }
    },
    {
      name        = "Tag Protection Ruleset"
      target      = "tag"
      enforcement = "active"

      # Conditions to specify which tags this ruleset applies to
      conditions = {
        ref_name = {
          include = ["v*"]
          exclude = []
        }
      }

      # Tag-specific rules
      rules = {
        # Tag name pattern rule (can only be used with target = "tag")
        tag_name_pattern = {
          name     = "Tag Name Pattern"
          operator = "regex"
          pattern  = "^v[0-9]+\\.[0-9]+\\.[0-9]+$"
          negate   = false
        }
      }
    }
  ]
}


resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
