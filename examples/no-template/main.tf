module "no_default_branch" {
  source = "../../"


  name        = "test-${basename(path.root)}"
  description = "Test repository without a default branch."
  topics      = ["any", "deployment", "devops", "gitops"]

  visibility         = "private"
  default_branch     = "prod"
  archive_on_destroy = false # Not a critical repo

  # homepage_url  = "https://argocd.core.maxim.run/applications/argocd/root-application" # TODO: change to the actual URL and de-hardcode
  has_issues    = false
  has_downloads = false # deprecated
  has_projects  = false
  has_wiki      = false
  # pages {}
  # security_and_analysis {}



  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true
  allow_auto_merge   = false

  # The following are valid combinations for the squash commit title and message: PR_TITLE and PR_BODY, PR_TITLE and BLANK, PR_TITLE and COMMIT_MESSAGES, COMMIT_OR_PR_TITLE and COMMIT_MESSAGES
  squash_merge_commit_title   = "COMMIT_OR_PR_TITLE"
  squash_merge_commit_message = "COMMIT_MESSAGES"

  delete_branch_on_merge = true

  web_commit_signoff_required = true

  # auto_init = true

  archived = false # TODO / test different combinations of archived and archive_on_destroy


  branches = [
    {
      name = "prod",

    },
    {
      name          = "dev",
    },
    {
      name          = "tests",
      source_branch = "prod"
    }
  ]

  environments = [
    {
      name = "dev",
      # prevent_self_review = true
      # reviewers {
      #   users = [data.github_user.current.id] # Reviewers only works with public repos https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment#required-reviewers
      # }
      protected = true
    },
    {
      name = "tests",
      # prevent_self_review = true
      # reviewers {
      #   users = [data.github_user.current.id] # Reviewers only works with public repos https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment#required-reviewers
      # }
      protected = true
    }
  ]
}