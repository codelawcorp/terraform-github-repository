# # Define random suffix for repository names to avoid conflicts
test {
  parallel = true
}

run "minimal" {
  command   = apply
  state_key = "minimal"

  module {
    source = "./examples/minimal"
  }
}


run "complete" {
  command   = apply
  state_key = "complete"

  module {
    source = "./examples/complete"
  }
}

# run "complete_gh_pages" {
#   command = apply
#   state_key = "complete"

#   module {
#     source = "./examples/complete"
#   }

#   variables {
#     pages = {
#       build_type = "legacy"
#       cname      = "pages.example.com"
#       source = {
#         branch = "gh-pages"
#         path   = "/"
#       }
#     }
#   }
# }



run "other" {
  command   = apply
  state_key = "other"
  module {
    source = "./examples/other"
  }
}



# provider "github" {
#   owner = "codelawcorp"
# }

# run "repo_many_args" {
#   command = apply


#   variables {
#     name        = "test-example-repo"
#     description = "An example repository created using Terraform"
#     visibility  = "private"

#     # Optional settings
#     homepage_url = "https://example.com"
#     topics       = ["terraform", "github", "example"]

#     # Feature flags
#     has_issues    = true
#     has_projects  = true
#     has_wiki      = true
#     has_downloads = true

#     # Merge settings
#     allow_merge_commit     = true
#     allow_squash_merge     = true
#     allow_rebase_merge     = true
#     delete_branch_on_merge = true

#     # Repository settings
#     is_template    = false
#     default_branch = "prod"
#     archived       = false

#     # Template configuration (if using a template repository)
#     template = {
#       owner                = "codelawcorp"
#       repository           = "template"
#       include_all_branches = true
#     }

#     branches = [
#       {
#         name = "gh-pages" # TODO / create pages branch if this is specified
#       }
#     ]


#     # Security and analysis features (optional)
#     #   security_and_analysis = {
#     #     advanced_security = {
#     #       status = "enabled"
#     #     }
#     #     secret_scanning = {
#     #       status = "enabled"
#     #     }
#     #     secret_scanning_push_protection = {
#     #       status = "enabled"
#     #     }
#     #   }
#     archive_on_destroy = false

#     environments = [
#       {
#         name = "prod"
#         reviewers = {
#           users = []
#           teams = []
#         }
#         protected = true
#         # tag_pattern   = "v*"
#         variables = [
#           {
#             name  = "API_URL"
#             value = "https://api.example.com/prod"
#           },
#           {
#             name  = "DEBUG_MODE"
#             value = "false"
#           }
#         ]
#         secrets = [
#           {
#             name  = "DEPLOY_TOKEN"
#             value = "secret-token-value"
#           },
#           {
#             name  = "DATABASE_PASSWORD"
#             value = "db-password-value"
#           }
#         ]
#       },
#       {
#         name = "stg"
#         reviewers = {
#           users = []
#         }
#         protected = true
#         # tag_pattern   = "stg-v*"
#         variables = [
#           {
#             name  = "API_URL"
#             value = "https://api.example.com/staging"
#           },
#           {
#             name  = "DEBUG_MODE"
#             value = "true"
#           }
#         ]
#       }
#     ]

#     github_actions_variables = [
#       {
#         name  = "CI_ENABLED"
#         value = "true"
#       },
#       {
#         name  = "DEPLOY_ENVIRONMENT"
#         value = "production"
#       }
#     ]

#     # This also automatically enables vulnerability_alerts
#     enable_dependabot_security_updates = true

#     # Use the dedicated github_repository_topics resource for topic management
#     use_repository_topics_resource = true

#     # Configure webhooks for the repository
#     webhooks = [
#       {
#         url          = "https://jenkins.example.com/github-webhook/"
#         content_type = "json"
#         events       = ["push", "pull_request"]
#       },
#       {
#         url          = "https://ci.example.com/webhook"
#         content_type = "form"
#         secret       = "secureSecret123"
#         events       = ["release"]
#       }
#     ]



#     # Tag protections disabled temporarily due to bug
#     # https://github.com/integrations/terraform-provider-github/issues/2477
#     # tag_protections = [
#     #   {
#     #     pattern = "v[0-9]+.[0-9]+.[0-9]+"  # Protect semantic versioning tags (default)
#     #   },
#     #   {
#     #     pattern = "release-*"  # Also protect release tags
#     #     allow_deletions = true  # But allow deletions for release tags
#     #   }
#     # ]


#     users = [
#       # {
#       #   username   = "example-user"
#       #   permission = "push"
#       # }
#     ]

#     teams = [
#       # {
#       #   team_id    = "admin-team"
#       #   permission = "admin"
#       # }
#     ]

#     # Define GitHub repository files
#     github_repository_files = {
#       "README.md" = {
#         content             = "# Example Repository\nThis is an example repository managed by Terraform."
#         branch              = "prod"
#         commit_message      = "Add README.md"
#         commit_author       = "Terraform Bot"
#         commit_email        = "test@test.com"
#         overwrite_on_create = true
#       }
#       "test.md" = {
#         content = "# A test file."
#         branch  = "random-branch"
#         # commit_message      = "Add README.md"
#         # commit_author       = "Terraform Bot"
#         # commit_email        = "test@test.com"
#         # overwrite_on_create = true
#       }
#       "test-default-branch.md" = {
#         content = "# A test file."
#         # branch              = "random-branch"
#         # commit_message      = "Add README.md"
#         # commit_author       = "Terraform Bot"
#         # commit_email        = "test@test.com"
#         # overwrite_on_create = true
#       }
#     }
#   }


#   # Assert that the repository is created successfully
#   assert {
#     condition     = output.name != ""
#     error_message = "Repository was not created successfully"
#   }
# }

