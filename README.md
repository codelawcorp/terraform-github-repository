# README
This is a reusable Terraform module for creating github repo and configuring it.  
The latest version is published to the official [Terraform registry](https://registry.terraform.io/modules/codelawcorp/repository/github/latest).

## Description 🤝

This is the most complete GitHub repo module out there.  
It bundles all resources related to `github_repository` and abstract complexities of github provider.

Github provider has a lot of issues - undocumented incompabilities, perpetual plans. If you face some issues, try another combination of parameters and report an issue here (we will add more docs, validations on the modules's side).  
**Do not blame Terraform core or this module - those is Github's provider implementation issues.**

Nonetheless, having the opportunity to spin up new projects in seconds and control configurations in a single place is a great advantage.

<!-- BEGIN_TF_DOCS -->


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 6.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | 6.6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_actions_environment_secret.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/actions_environment_secret) | resource |
| [github_actions_environment_variable.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/actions_environment_variable) | resource |
| [github_actions_secret.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_variable.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/actions_variable) | resource |
| [github_branch.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/branch) | resource |
| [github_branch_default.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/branch_default) | resource |
| [github_branch_protection.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/branch_protection) | resource |
| [github_issue_label.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/issue_label) | resource |
| [github_repository.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/repository) | resource |
| [github_repository_autolink_reference.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/repository_autolink_reference) | resource |
| [github_repository_collaborator.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/repository_collaborator) | resource |
| [github_repository_custom_property.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/repository_custom_property) | resource |
| [github_repository_dependabot_security_updates.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/repository_dependabot_security_updates) | resource |
| [github_repository_deploy_key.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/repository_deploy_key) | resource |
| [github_repository_environment.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/repository_environment) | resource |
| [github_repository_environment_deployment_policy.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/repository_environment_deployment_policy) | resource |
| [github_repository_file.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/repository_file) | resource |
| [github_repository_project.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/repository_project) | resource |
| [github_repository_topics.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/repository_topics) | resource |
| [github_repository_webhook.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/repository_webhook) | resource |
| [github_team_repository.this](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/team_repository) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_auto_merge"></a> [allow\_auto\_merge](#input\_allow\_auto\_merge) | Set to true to allow auto-merging pull requests on the repository | `bool` | `false` | no |
| <a name="input_allow_merge_commit"></a> [allow\_merge\_commit](#input\_allow\_merge\_commit) | Set to false to disable merge commits on the repository | `bool` | `true` | no |
| <a name="input_allow_rebase_merge"></a> [allow\_rebase\_merge](#input\_allow\_rebase\_merge) | Set to false to disable rebase merges on the repository | `bool` | `true` | no |
| <a name="input_allow_squash_merge"></a> [allow\_squash\_merge](#input\_allow\_squash\_merge) | Set to false to disable squash merges on the repository | `bool` | `true` | no |
| <a name="input_archive_on_destroy"></a> [archive\_on\_destroy](#input\_archive\_on\_destroy) | Set to true to archive the repository instead of deleting it when the resource is destroyed | `bool` | `true` | no |
| <a name="input_archived"></a> [archived](#input\_archived) | Specifies if the repository should be archived | `bool` | `false` | no |
| <a name="input_auto_init"></a> [auto\_init](#input\_auto\_init) | Set to true to produce an initial commit in the repository. Ignored if template is used. | `bool` | `false` | no |
| <a name="input_autolink_references"></a> [autolink\_references](#input\_autolink\_references) | A list of autolink references to create for the repository | <pre>list(object({<br/>    key_prefix          = string<br/>    target_url_template = string<br/>    is_alphanumeric     = optional(bool)<br/>  }))</pre> | `[]` | no |
| <a name="input_branches"></a> [branches](#input\_branches) | List of branch configurations to create | <pre>list(object({<br/>    name = string<br/>    # default       = optional(bool) # TODO use it instead of default_branch<br/>    source_branch = optional(string)<br/>    source_sha    = optional(string)<br/>    # TODO add missing options from https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_protection<br/>    protection = optional(object({<br/>      enforce_admins = optional(bool)<br/>      required_status_checks = optional(object({<br/>        strict   = optional(bool)<br/>        contexts = optional(list(string))<br/>      }))<br/>      required_pull_request_reviews = optional(object({<br/>        dismiss_stale_reviews           = optional(bool)<br/>        restrict_dismissals             = optional(bool)<br/>        dismissal_restrictions          = optional(list(string))<br/>        require_code_owner_reviews      = optional(bool)<br/>        required_approving_review_count = optional(number)<br/>      }))<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_custom_properties"></a> [custom\_properties](#input\_custom\_properties) | Custom properties to set on the repository. Must be defined on the organization level first. | <pre>list(object({<br/>    property_name  = string<br/>    property_value = string<br/>    property_type  = optional(string, "string")<br/>  }))</pre> | `[]` | no |
| <a name="input_default_branch"></a> [default\_branch](#input\_default\_branch) | The name of the default branch of the repository. | `string` | `"main"` | no |
| <a name="input_delete_branch_on_merge"></a> [delete\_branch\_on\_merge](#input\_delete\_branch\_on\_merge) | Automatically delete head branch after a pull request is merged | `bool` | `false` | no |
| <a name="input_deploy_keys"></a> [deploy\_keys](#input\_deploy\_keys) | List of SSH deploy keys to add to the repository | <pre>list(object({<br/>    title     = string<br/>    key       = string<br/>    read_only = optional(bool, true)<br/>  }))</pre> | `[]` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the GitHub repository | `string` | `""` | no |
| <a name="input_enable_dependabot_security_updates"></a> [enable\_dependabot\_security\_updates](#input\_enable\_dependabot\_security\_updates) | Whether to enable Dependabot security updates for the repository. This automatically enables vulnerability alerts as well. | `bool` | `true` | no |
| <a name="input_environments"></a> [environments](#input\_environments) | GitHub repository environments to create | <pre>list(object({<br/>    name = string<br/>    reviewers = optional(object({<br/>      teams = optional(list(string), [])<br/>      users = optional(list(string), [])<br/>    }))<br/>    protected = optional(bool, false)<br/>    variables = optional(list(object({<br/>      name  = string<br/>      value = string<br/>    })), [])<br/>    secrets = optional(list(object({<br/>      name  = string<br/>      value = string<br/>    })), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_github_actions_secrets"></a> [github\_actions\_secrets](#input\_github\_actions\_secrets) | GitHub Actions secrets to set on the repository | <pre>list(object({<br/>    name  = string<br/>    value = string<br/>  }))</pre> | `[]` | no |
| <a name="input_github_actions_variables"></a> [github\_actions\_variables](#input\_github\_actions\_variables) | GitHub Actions variables to set on the repository | <pre>list(object({<br/>    name  = string<br/>    value = string<br/>  }))</pre> | `[]` | no |
| <a name="input_github_repository_files"></a> [github\_repository\_files](#input\_github\_repository\_files) | A map of files to create in the repository. Each key is the file path, and the value is a map with file content and other properties. | <pre>map(object({<br/>    content                         = string<br/>    branch                          = optional(string, null)<br/>    commit_sha                      = optional(string, null)<br/>    commit_message                  = optional(string, "Managed by Terraform")<br/>    commit_author                   = optional(string, null)<br/>    commit_email                    = optional(string, null)<br/>    overwrite_on_create             = optional(bool, false)<br/>    autocreate_branch               = optional(bool, true)<br/>    autocreate_branch_source_branch = optional(string, null)<br/>    autocreate_branch_source_sha    = optional(string, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_gitignore_template"></a> [gitignore\_template](#input\_gitignore\_template) | Use the name of the template without the extension. For example, 'Haskell' | `string` | `null` | no |
| <a name="input_has_downloads"></a> [has\_downloads](#input\_has\_downloads) | Set to true to enable the GitHub Downloads features on the repository (deprecated) | `bool` | `false` | no |
| <a name="input_has_issues"></a> [has\_issues](#input\_has\_issues) | Set to true to enable the GitHub Issues features on the repository | `bool` | `true` | no |
| <a name="input_has_projects"></a> [has\_projects](#input\_has\_projects) | Set to true to enable the GitHub Projects features on the repository | `bool` | `false` | no |
| <a name="input_has_wiki"></a> [has\_wiki](#input\_has\_wiki) | Set to true to enable the GitHub Wiki features on the repository | `bool` | `false` | no |
| <a name="input_homepage_url"></a> [homepage\_url](#input\_homepage\_url) | URL of a page describing the project. | `string` | `null` | no |
| <a name="input_is_template"></a> [is\_template](#input\_is\_template) | Set to true to tell GitHub that this is a template repository | `bool` | `false` | no |
| <a name="input_issue_label"></a> [issue\_label](#input\_issue\_label) | A list of issue label | <pre>list(object({<br/>    name        = string<br/>    color       = string<br/>    description = optional(string, "")<br/>  }))</pre> | `[]` | no |
| <a name="input_license_template"></a> [license\_template](#input\_license\_template) | Use the name of the template without the extension. For example, 'mit' or 'mpl-2.0' | `string` | `null` | no |
| <a name="input_merge_commit_message"></a> [merge\_commit\_message](#input\_merge\_commit\_message) | The format of the commit message body when using merge commit. Can be one of: PR\_BODY, COMMIT\_MESSAGES, BLANK | `string` | `"PR_BODY"` | no |
| <a name="input_merge_commit_title"></a> [merge\_commit\_title](#input\_merge\_commit\_title) | The format of the commit message when using merge commit. Can be one of: PR\_TITLE, MERGE\_MESSAGE | `string` | `"PR_TITLE"` | no |
| <a name="input_merge_commit_validation"></a> [merge\_commit\_validation](#input\_merge\_commit\_validation) | n/a | `string` | `"_placeholder_for_validation"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the GitHub repository | `string` | n/a | yes |
| <a name="input_pages"></a> [pages](#input\_pages) | The repository's GitHub Pages configuration. Do not apply this configuration before the first apply if the source branch does not exist. Requires a paid GH plan. | <pre>object({<br/>    build_type = optional(string, "legacy")<br/>    cname      = optional(string, null)<br/>    source = object({<br/>      branch = string<br/>      path   = string<br/>    })<br/>  })</pre> | `null` | no |
| <a name="input_projects"></a> [projects](#input\_projects) | A list of project configurations to create for the repository | <pre>list(object({<br/>    name       = string<br/>    repository = string<br/>    body       = optional(string, null)<br/>  }))</pre> | `[]` | no |
| <a name="input_security_and_analysis"></a> [security\_and\_analysis](#input\_security\_and\_analysis) | Security and analysis features for the repository | <pre>object({<br/>    advanced_security = object({<br/>      status = string<br/>    })<br/>    secret_scanning = object({<br/>      status = string<br/>    })<br/>    secret_scanning_push_protection = object({<br/>      status = string<br/>    })<br/>  })</pre> | `null` | no |
| <a name="input_squash_merge_commit_message"></a> [squash\_merge\_commit\_message](#input\_squash\_merge\_commit\_message) | The format of the commit message body when using squash merge. Can be one of: PR\_BODY, COMMIT\_MESSAGES, BLANK | `string` | `"COMMIT_MESSAGES"` | no |
| <a name="input_squash_merge_commit_title"></a> [squash\_merge\_commit\_title](#input\_squash\_merge\_commit\_title) | The format of the commit message when using squash merge. Can be one of: PR\_TITLE, COMMIT\_OR\_PR\_TITLE | `string` | `"COMMIT_OR_PR_TITLE"` | no |
| <a name="input_teams"></a> [teams](#input\_teams) | List of repository teams to add to the repository | <pre>list(object({<br/>    team_id    = string<br/>    permission = string<br/>  }))</pre> | `[]` | no |
| <a name="input_template"></a> [template](#input\_template) | Template configuration for the GitHub repository | <pre>object({<br/>    owner                = string<br/>    repository           = string<br/>    include_all_branches = bool<br/>  })</pre> | `null` | no |
| <a name="input_topics"></a> [topics](#input\_topics) | List of topics to add to the repository | `list(string)` | `[]` | no |
| <a name="input_use_repository_topics_resource"></a> [use\_repository\_topics\_resource](#input\_use\_repository\_topics\_resource) | Whether to use github\_repository\_topics resource instead of setting topics in the github\_repository resource. This is useful for managing topics separately. | `bool` | `false` | no |
| <a name="input_users"></a> [users](#input\_users) | List of repository collaborators to add to the repository | <pre>list(object({<br/>    username   = string<br/>    permission = string # pull, push, admin, maintain, triage<br/>  }))</pre> | `[]` | no |
| <a name="input_visibility"></a> [visibility](#input\_visibility) | Visibility of the GitHub repository (public, private, or internal) | `string` | `"private"` | no |
| <a name="input_vulnerability_alerts"></a> [vulnerability\_alerts](#input\_vulnerability\_alerts) | Set to true to enable security alerts for vulnerable dependencies. Will be automatically enabled if enable\_dependabot\_security\_updates is true. | `bool` | `false` | no |
| <a name="input_web_commit_signoff_required"></a> [web\_commit\_signoff\_required](#input\_web\_commit\_signoff\_required) | Require contributors to sign off on web-based commits | `bool` | `false` | no |
| <a name="input_webhooks"></a> [webhooks](#input\_webhooks) | List of webhook configurations to create for the repository | <pre>list(object({<br/>    url          = string<br/>    content_type = string<br/>    secret       = optional(string)<br/>    insecure_ssl = optional(bool, false)<br/>    active       = optional(bool, true)<br/>    events       = list(string)<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_description"></a> [description](#output\_description) | The description of the repository |
| <a name="output_name"></a> [name](#output\_name) | The name of the repository |
| <a name="output_pages_url"></a> [pages\_url](#output\_pages\_url) | The URL of the GitHub Pages site |
| <a name="output_visibility"></a> [visibility](#output\_visibility) | The visibility of the repository |


<!-- END_TF_DOCS -->


## Contributing 🐙
See [CONTRIBUTING.md](.github/CONTRIBUTING.md)
