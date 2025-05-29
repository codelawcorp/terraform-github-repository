module "another_repo" {
  source = "../../"

  name               = "test-${basename(path.root)}"
  archive_on_destroy = false

  default_branch = "main"

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

  deploy_keys = [
    {
      title = "Some CI Key"
      # this is how to generate the key // ssh-keygen -f test
      key       = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKB/4GlDREJaArBSKACPHpczJGrw2SoDRE4y5MyBN+7+ some-metadata"
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
