# README

This is a reusable Terraform module for creating github repo and configuring it.  
The latest version is published to the official [Terraform registry](https://registry.terraform.io/modules/codelawcorp/repository/github/latest).

## Description 🤝

This is the most complete GitHub repo module out there.  
It bundles all resources related to `github_repository` and abstract complexities of github provider.

<!-- BEGIN_TF_DOCS -->

# Examples

### Minimal example

```hcl
module "github_repository_minimal" {
  source = "../../"
  name   = "test-example-minimal"

  archive_on_destroy = false # Not a critical repo
}

```

### Complete example

```hcl
module "github_repository_complete" {
  source = "../../"

  name        = "test-example-complete"
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
      name = "gh-pages"
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
      key_prefix          = "PR-"
      target_url_template = "https://example.com/pull/PR-<num>"
      is_alphanumeric     = false # Default is true
    }
  ]


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

```

## Requirements

| Name                                                            | Version  |
| --------------------------------------------------------------- | -------- |
| <a name="requirement_github"></a> [github](#requirement_github) | ~> 6.6.0 |

## Providers

| Name                                                      | Version  |
| --------------------------------------------------------- | -------- |
| <a name="provider_github"></a> [github](#provider_github) | ~> 6.6.0 |

## Modules

No modules.

## Resources

| Name                                                                                                                                                                            | Type     |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [github_actions_environment_secret.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/actions_environment_secret)                             | resource |
| [github_actions_environment_variable.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/actions_environment_variable)                         | resource |
| [github_actions_repository_permissions.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/actions_repository_permissions)                     | resource |
| [github_actions_secret.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/actions_secret)                                                     | resource |
| [github_actions_variable.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/actions_variable)                                                 | resource |
| [github_branch.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/branch)                                                                     | resource |
| [github_branch_default.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/branch_default)                                                     | resource |
| [github_branch_protection.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/branch_protection)                                               | resource |
| [github_issue_label.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/issue_label)                                                           | resource |
| [github_repository.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/repository)                                                             | resource |
| [github_repository_autolink_reference.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/repository_autolink_reference)                       | resource |
| [github_repository_collaborator.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/repository_collaborator)                                   | resource |
| [github_repository_custom_property.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/repository_custom_property)                             | resource |
| [github_repository_dependabot_security_updates.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/repository_dependabot_security_updates)     | resource |
| [github_repository_deploy_key.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/repository_deploy_key)                                       | resource |
| [github_repository_environment.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/repository_environment)                                     | resource |
| [github_repository_environment_deployment_policy.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/repository_environment_deployment_policy) | resource |
| [github_repository_file.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/repository_file)                                                   | resource |
| [github_repository_topics.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/repository_topics)                                               | resource |
| [github_repository_webhook.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/repository_webhook)                                             | resource |
| [github_team_repository.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/team_repository)                                                   | resource |

We used best effort to make sure that default values match provider's defaults to avoid confusions.  
Instead of using variable prefixes, we use nested objects: e.g. `branch -> branch protection, environment -> environment protection`. This naturally leads to more readable code, which is one of the goals of this module.
When variable is an object, there is a comment with a link to the provider's documentation for the related resource.

## Inputs

| Name                                                                                                                                    | Description                                                                                                                                                                  | Type                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | Default                         | Required |
| --------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------- | :------: |
| <a name="input__merge_commit_validation"></a> [\_merge_commit_validation](#input__merge_commit_validation)                              | Do not use this variable. It is used for validation of the merge_commit_title and merge_commit_message variables.                                                            | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | `"_placeholder_for_validation"` |    no    |
| <a name="input_allow_auto_merge"></a> [allow_auto_merge](#input_allow_auto_merge)                                                       | Set to true to allow auto-merging pull requests on the repository                                                                                                            | `bool`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | `false`                         |    no    |
| <a name="input_allow_merge_commit"></a> [allow_merge_commit](#input_allow_merge_commit)                                                 | Set to false to disable merge commits on the repository                                                                                                                      | `bool`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | `true`                          |    no    |
| <a name="input_allow_rebase_merge"></a> [allow_rebase_merge](#input_allow_rebase_merge)                                                 | Set to false to disable rebase merges on the repository                                                                                                                      | `bool`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | `true`                          |    no    |
| <a name="input_allow_squash_merge"></a> [allow_squash_merge](#input_allow_squash_merge)                                                 | Set to false to disable squash merges on the repository                                                                                                                      | `bool`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | `true`                          |    no    |
| <a name="input_archive_on_destroy"></a> [archive_on_destroy](#input_archive_on_destroy)                                                 | Set to true to archive the repository instead of deleting it when the resource is destroyed                                                                                  | `bool`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | `true`                          |    no    |
| <a name="input_archived"></a> [archived](#input_archived)                                                                               | Specifies if the repository should be archived                                                                                                                               | `bool`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | `false`                         |    no    |
| <a name="input_auto_init"></a> [auto_init](#input_auto_init)                                                                            | Set to true to produce an initial commit in the repository. Is not compatible with template.                                                                                 | `bool`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | `false`                         |    no    |
| <a name="input_autolink_references"></a> [autolink_references](#input_autolink_references)                                              | A list of autolink references to create for the repository                                                                                                                   | <pre>list(object({<br/> key_prefix = string<br/> target_url_template = string<br/> is_alphanumeric = optional(bool)<br/> }))</pre>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | `[]`                            |    no    |
| <a name="input_branches"></a> [branches](#input_branches)                                                                               | List of branch configurations to create                                                                                                                                      | <pre>list(object({<br/> name = string<br/> # default = optional(bool) # TODO use it instead of default_branch<br/> source_branch = optional(string)<br/> source_sha = optional(string)<br/> # TODO add missing options from https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_protection<br/> protection = optional(object({ # Empty object means to protect with defaults<br/> enforce_admins = optional(bool)<br/> # pattern is always name of the branch. This is how this module works.<br/> required_status_checks = optional(object({<br/> strict = optional(bool)<br/> contexts = optional(list(string))<br/> }))<br/> required_pull_request_reviews = optional(object({<br/> dismiss_stale_reviews = optional(bool)<br/> restrict_dismissals = optional(bool)<br/> dismissal_restrictions = optional(list(string))<br/> require_code_owner_reviews = optional(bool)<br/> required_approving_review_count = optional(number)<br/> }))<br/> }))<br/> }))</pre> | `[]`                            |    no    |
| <a name="input_custom_properties"></a> [custom_properties](#input_custom_properties)                                                    | Custom properties to set on the repository. Must be defined on the organization level first.                                                                                 | <pre>list(object({<br/> property_name = string<br/> property_value = string<br/> property_type = optional(string, "string")<br/> }))</pre>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | `[]`                            |    no    |
| <a name="input_default_branch"></a> [default_branch](#input_default_branch)                                                             | The name of the default branch of the repository.                                                                                                                            | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | `"main"`                        |    no    |
| <a name="input_delete_branch_on_merge"></a> [delete_branch_on_merge](#input_delete_branch_on_merge)                                     | Automatically delete head branch after a pull request is merged                                                                                                              | `bool`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | `false`                         |    no    |
| <a name="input_deploy_keys"></a> [deploy_keys](#input_deploy_keys)                                                                      | List of SSH deploy keys to add to the repository                                                                                                                             | <pre>list(object({<br/> title = string<br/> key = string<br/> read_only = optional(bool, true)<br/> }))</pre>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | `[]`                            |    no    |
| <a name="input_description"></a> [description](#input_description)                                                                      | Description of the GitHub repository                                                                                                                                         | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | `""`                            |    no    |
| <a name="input_enable_dependabot_security_updates"></a> [enable_dependabot_security_updates](#input_enable_dependabot_security_updates) | Whether to enable Dependabot security updates for the repository. This automatically enables vulnerability alerts as well.                                                   | `bool`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | `true`                          |    no    |
| <a name="input_environments"></a> [environments](#input_environments)                                                                   | GitHub repository environments to create                                                                                                                                     | <pre>list(object({<br/> name = string<br/> reviewers = optional(object({<br/> teams = optional(list(string), [])<br/> users = optional(list(string), [])<br/> }))<br/> protected = optional(bool, false)<br/> variables = optional(list(object({<br/> name = string<br/> value = string<br/> })), [])<br/> secrets = optional(list(object({<br/> name = string<br/> value = string<br/> })), [])<br/> }))</pre>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | `[]`                            |    no    |
| <a name="input_github_actions_repository_permissions"></a> [github_actions_permissions](#input_github_actions_permissions)              | GitHub Actions permissions configuration                                                                                                                                     | <pre>object({<br/> allowed_actions = optional(string, "all") # all, local_only, or selected<br/> enabled = optional(string, "all") # all, none, or selected<br/> allowed_actions_config = optional(object({<br/> github_owned_allowed = optional(bool, true)<br/> verified_allowed = optional(bool, true)<br/> patterns_allowed = optional(list(string), [])<br/> }))<br/> })</pre>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | `null`                          |    no    |
| <a name="input_github_actions_secrets"></a> [github_actions_secrets](#input_github_actions_secrets)                                     | GitHub Actions secrets to set on the repository                                                                                                                              | <pre>list(object({<br/> name = string<br/> value = string<br/> }))</pre>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | `[]`                            |    no    |
| <a name="input_github_actions_variables"></a> [github_actions_variables](#input_github_actions_variables)                               | GitHub Actions variables to set on the repository                                                                                                                            | <pre>list(object({<br/> name = string<br/> value = string<br/> }))</pre>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | `[]`                            |    no    |
| <a name="input_github_repository_files"></a> [github_repository_files](#input_github_repository_files)                                  | A map of files to create in the repository. Each key is the file path, and the value is a map with file content and other properties.                                        | <pre>map(object({<br/> content = string<br/> branch = optional(string, null)<br/> commit_sha = optional(string, null)<br/> commit_message = optional(string, "Managed by Terraform")<br/> commit_author = optional(string, null)<br/> commit_email = optional(string, null)<br/> overwrite_on_create = optional(bool, false)<br/> autocreate_branch = optional(bool, true)<br/> autocreate_branch_source_branch = optional(string, null)<br/> autocreate_branch_source_sha = optional(string, null)<br/> }))</pre>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | `{}`                            |    no    |
| <a name="input_gitignore_template"></a> [gitignore_template](#input_gitignore_template)                                                 | Use the name of the template without the extension. For example, 'Haskell'                                                                                                   | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | `null`                          |    no    |
| <a name="input_has_discussions"></a> [has_discussions](#input_has_discussions)                                                          | Set to true to enable GitHub Discussions on the repository                                                                                                                   | `bool`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | `false`                         |    no    |
| <a name="input_has_downloads"></a> [has_downloads](#input_has_downloads)                                                                | Set to true to enable the GitHub Downloads features on the repository (deprecated)                                                                                           | `bool`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | `false`                         |    no    |
| <a name="input_has_issues"></a> [has_issues](#input_has_issues)                                                                         | Set to true to enable the GitHub Issues features on the repository                                                                                                           | `bool`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | `false`                         |    no    |
| <a name="input_has_projects"></a> [has_projects](#input_has_projects)                                                                   | Set to true to enable the GitHub Projects features on the repository                                                                                                         | `bool`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | `false`                         |    no    |
| <a name="input_has_wiki"></a> [has_wiki](#input_has_wiki)                                                                               | Set to true to enable the GitHub Wiki features on the repository                                                                                                             | `bool`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | `false`                         |    no    |
| <a name="input_homepage_url"></a> [homepage_url](#input_homepage_url)                                                                   | URL of a page describing the project.                                                                                                                                        | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | `null`                          |    no    |
| <a name="input_is_template"></a> [is_template](#input_is_template)                                                                      | Set to true to tell GitHub that this is a template repository                                                                                                                | `bool`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | `false`                         |    no    |
| <a name="input_issue_label"></a> [issue_label](#input_issue_label)                                                                      | A list of issue label                                                                                                                                                        | <pre>list(object({<br/> name = string<br/> color = string<br/> description = optional(string, "")<br/> }))</pre>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | `[]`                            |    no    |
| <a name="input_license_template"></a> [license_template](#input_license_template)                                                       | Use the name of the template without the extension. For example, 'mit' or 'mpl-2.0'                                                                                          | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | `null`                          |    no    |
| <a name="input_merge_commit_message"></a> [merge_commit_message](#input_merge_commit_message)                                           | The format of the commit message body when using merge commit. Can be one of: PR_BODY, COMMIT_MESSAGES, BLANK                                                                | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | `"PR_BODY"`                     |    no    |
| <a name="input_merge_commit_title"></a> [merge_commit_title](#input_merge_commit_title)                                                 | The format of the commit message when using merge commit. Can be one of: PR_TITLE, MERGE_MESSAGE                                                                             | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | `"PR_TITLE"`                    |    no    |
| <a name="input_name"></a> [name](#input_name)                                                                                           | Name of the GitHub repository                                                                                                                                                | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | n/a                             |   yes    |
| <a name="input_pages"></a> [pages](#input_pages)                                                                                        | The repository's GitHub Pages configuration. Do not apply this configuration before the first apply if the source branch (gh-pages) does not exist. Requires a paid GH plan. | <pre>object({<br/> build_type = optional(string, "legacy")<br/> cname = optional(string, null)<br/> source = object({<br/> branch = string<br/> path = string<br/> })<br/> })</pre>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | `null`                          |    no    |
| <a name="input_security_and_analysis"></a> [security_and_analysis](#input_security_and_analysis)                                        | Security and analysis features for the repository                                                                                                                            | <pre>object({<br/> advanced_security = object({<br/> status = string<br/> })<br/> secret_scanning = object({<br/> status = string<br/> })<br/> secret_scanning_push_protection = object({<br/> status = string<br/> })<br/> })</pre>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | `null`                          |    no    |
| <a name="input_squash_merge_commit_message"></a> [squash_merge_commit_message](#input_squash_merge_commit_message)                      | The format of the commit message body when using squash merge. Can be one of: PR_BODY, COMMIT_MESSAGES, BLANK                                                                | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | `"COMMIT_MESSAGES"`             |    no    |
| <a name="input_squash_merge_commit_title"></a> [squash_merge_commit_title](#input_squash_merge_commit_title)                            | The format of the commit message when using squash merge. Can be one of: PR_TITLE, COMMIT_OR_PR_TITLE                                                                        | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | `"COMMIT_OR_PR_TITLE"`          |    no    |
| <a name="input_teams"></a> [teams](#input_teams)                                                                                        | List of repository teams to add to the repository                                                                                                                            | <pre>list(object({<br/> team_id = string<br/> permission = string<br/> }))</pre>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | `[]`                            |    no    |
| <a name="input_template"></a> [template](#input_template)                                                                               | Template configuration for the GitHub repository                                                                                                                             | <pre>object({<br/> owner = string<br/> repository = string<br/> include_all_branches = bool<br/> })</pre>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | `null`                          |    no    |
| <a name="input_topics"></a> [topics](#input_topics)                                                                                     | List of topics to add to the repository                                                                                                                                      | `list(string)`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | `[]`                            |    no    |
| <a name="input_use_repository_topics_resource"></a> [use_repository_topics_resource](#input_use_repository_topics_resource)             | Whether to use github_repository_topics resource instead of setting topics in the github_repository resource. This is useful for managing topics separately.                 | `bool`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | `false`                         |    no    |
| <a name="input_users"></a> [users](#input_users)                                                                                        | List of repository collaborators to add to the repository                                                                                                                    | <pre>list(object({<br/> username = string<br/> permission = string # pull, push, admin, maintain, triage<br/> }))</pre>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | `[]`                            |    no    |
| <a name="input_visibility"></a> [visibility](#input_visibility)                                                                         | Visibility of the GitHub repository (public, private, or internal)                                                                                                           | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | `"private"`                     |    no    |
| <a name="input_vulnerability_alerts"></a> [vulnerability_alerts](#input_vulnerability_alerts)                                           | Set to true to enable security alerts for vulnerable dependencies. Will be automatically enabled if enable_dependabot_security_updates is true.                              | `bool`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | `false`                         |    no    |
| <a name="input_web_commit_signoff_required"></a> [web_commit_signoff_required](#input_web_commit_signoff_required)                      | Require contributors to sign off on web-based commits                                                                                                                        | `bool`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | `false`                         |    no    |
| <a name="input_webhooks"></a> [webhooks](#input_webhooks)                                                                               | List of webhook configurations to create for the repository                                                                                                                  | <pre>list(object({<br/> url = string<br/> content_type = string<br/> secret = optional(string)<br/> insecure_ssl = optional(bool, false)<br/> active = optional(bool, true)<br/> events = list(string)<br/> }))</pre>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | `[]`                            |    no    |

## Outputs

| Name                                                                                                                                                                                   | Description                                    |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------- |
| <a name="output_allow_auto_merge"></a> [allow_auto_merge](#output_allow_auto_merge)                                                                                                    | Whether auto merge is allowed                  |
| <a name="output_allow_merge_commit"></a> [allow_merge_commit](#output_allow_merge_commit)                                                                                              | Whether merge commits are allowed              |
| <a name="output_allow_rebase_merge"></a> [allow_rebase_merge](#output_allow_rebase_merge)                                                                                              | Whether rebase merge is allowed                |
| <a name="output_allow_squash_merge"></a> [allow_squash_merge](#output_allow_squash_merge)                                                                                              | Whether squash merge is allowed                |
| <a name="output_archived"></a> [archived](#output_archived)                                                                                                                            | Whether the repository is archived             |
| <a name="output_delete_branch_on_merge"></a> [delete_branch_on_merge](#output_delete_branch_on_merge)                                                                                  | Whether to delete branch on merge              |
| <a name="output_description"></a> [description](#output_description)                                                                                                                   | The description of the repository              |
| <a name="output_github_actions_environment_secrets"></a> [github_actions_environment_secrets](#output_github_actions_environment_secrets)                                              | Environment secrets for GitHub Actions         |
| <a name="output_github_actions_environment_variables"></a> [github_actions_environment_variables](#output_github_actions_environment_variables)                                        | Environment variables for GitHub Actions       |
| <a name="output_github_actions_repository_permissions"></a> [github_actions_permissions](#output_github_actions_permissions)                                                           | GitHub Actions permissions configuration       |
| <a name="output_github_actions_secrets"></a> [github_actions_secrets](#output_github_actions_secrets)                                                                                  | GitHub Actions secrets                         |
| <a name="output_github_actions_variables"></a> [github_actions_variables](#output_github_actions_variables)                                                                            | GitHub Actions variables for the repository    |
| <a name="output_github_branch_default"></a> [github_branch_default](#output_github_branch_default)                                                                                     | Default branch configuration                   |
| <a name="output_github_branch_protections"></a> [github_branch_protections](#output_github_branch_protections)                                                                         | Branch protection rules                        |
| <a name="output_github_branches"></a> [github_branches](#output_github_branches)                                                                                                       | Repository branches                            |
| <a name="output_github_issue_labels"></a> [github_issue_labels](#output_github_issue_labels)                                                                                           | Issue labels                                   |
| <a name="output_github_repository_autolink_references"></a> [github_repository_autolink_references](#output_github_repository_autolink_references)                                     | Repository autolink references                 |
| <a name="output_github_repository_collaborators"></a> [github_repository_collaborators](#output_github_repository_collaborators)                                                       | Repository collaborators                       |
| <a name="output_github_repository_custom_properties"></a> [github_repository_custom_properties](#output_github_repository_custom_properties)                                           | Repository custom properties                   |
| <a name="output_github_repository_dependabot_security_updates"></a> [github_repository_dependabot_security_updates](#output_github_repository_dependabot_security_updates)             | Dependabot security updates configuration      |
| <a name="output_github_repository_deploy_keys"></a> [github_repository_deploy_keys](#output_github_repository_deploy_keys)                                                             | Repository deploy keys                         |
| <a name="output_github_repository_environment_deployment_policies"></a> [github_repository_environment_deployment_policies](#output_github_repository_environment_deployment_policies) | Environment deployment policies                |
| <a name="output_github_repository_environments"></a> [github_repository_environments](#output_github_repository_environments)                                                          | Repository environments                        |
| <a name="output_github_repository_files"></a> [github_repository_files](#output_github_repository_files)                                                                               | Repository files                               |
| <a name="output_github_repository_topics"></a> [github_repository_topics](#output_github_repository_topics)                                                                            | Repository topics                              |
| <a name="output_github_repository_webhooks"></a> [github_repository_webhooks](#output_github_repository_webhooks)                                                                      | Repository webhooks                            |
| <a name="output_github_team_repositories"></a> [github_team_repositories](#output_github_team_repositories)                                                                            | Team repository permissions                    |
| <a name="output_has_discussions"></a> [has_discussions](#output_has_discussions)                                                                                                       | Whether the repository has discussions enabled |
| <a name="output_has_downloads"></a> [has_downloads](#output_has_downloads)                                                                                                             | Whether the repository has downloads enabled   |
| <a name="output_has_issues"></a> [has_issues](#output_has_issues)                                                                                                                      | Whether the repository has issues enabled      |
| <a name="output_has_projects"></a> [has_projects](#output_has_projects)                                                                                                                | Whether the repository has projects enabled    |
| <a name="output_has_wiki"></a> [has_wiki](#output_has_wiki)                                                                                                                            | Whether the repository has wiki enabled        |
| <a name="output_homepage_url"></a> [homepage_url](#output_homepage_url)                                                                                                                | The homepage URL of the repository             |
| <a name="output_is_template"></a> [is_template](#output_is_template)                                                                                                                   | Whether the repository is a template           |
| <a name="output_name"></a> [name](#output_name)                                                                                                                                        | The name of the repository                     |
| <a name="output_pages_url"></a> [pages_url](#output_pages_url)                                                                                                                         | The URL of the GitHub Pages site               |
| <a name="output_visibility"></a> [visibility](#output_visibility)                                                                                                                      | The visibility of the repository               |
| <a name="output_vulnerability_alerts"></a> [vulnerability_alerts](#output_vulnerability_alerts)                                                                                        | Whether vulnerability alerts are enabled       |
| <a name="output_web_commit_signoff_required"></a> [web_commit_signoff_required](#output_web_commit_signoff_required)                                                                   | Whether web commit signoff is required         |

<!-- END_TF_DOCS -->

## Issues

While the **GitHub provider is functional, it has several limitations and edge cases** that require workarounds. It's not the most robust or fully-featured implementation compared to other Terraform providers. Undocumented incompabilities, sometitms perpetual plans.  
If you face some issues, try another combination of parameters and report an issue here (we will add more docs, validations on the modules's side). Thank you!

Nonetheless, having the opportunity to spin up new projects in seconds and control configurations in a single place is a great advantage.

## Contributing 🐙

See [CONTRIBUTING.md](https://github.com/codelawcorp/terraform-github-repository/tree/prod/.github/CONTRIBUTING.md)

## Authors

Module is maintained by [Max Onyx](https://github.com/magzim21) with help from [Azusa Kadota](https://github.com/kadazusa) and [these awesome contributors](https://github.com/codelawcorp/terraform-github-repository/graphs/contributors).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/codelawcorp/terraform-github-repository/tree/prod/LICENSE.md) for full details.

## Need Help?

[CodeLaw.pro](https://codelaw.pro) — helping to structure Terraform code for maintanability and scalability - no frameworks, no subscriptions, no vendor lock-in.

Reach out for **Internal Development Platform** built for your needs that you actually own in just 3 days (+ migrations).
