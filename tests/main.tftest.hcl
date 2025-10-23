

# provider "github" {
#   owner = "codelawcorp"
# }
test {
  parallel = true # This is ignored for some reason
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

run "no_template" {
  command   = apply
  state_key = "no_template"
  module {
    source = "./examples/no-template"
  }
}


run "bootsrap" {
  command   = apply
  state_key = "bootsrap"

  module {
    source = "./examples/bootstrap"

  }
  variables {
    tf_cloud_organization = "magzim21"
    tf_cloud_workspace    = "github-test"
    # tfe_token        = "placeholder" # This is sensitive. Pass via TF_VAR_tfe_token
    # github_token          = "placeholder" # This is sensitive. Pass via TF_VAR_github_token
  }
}
run "branch_variations_main" {
  command   = apply
  state_key = "branch-variations"
  variables {
    default_branch = "main"
  }

  module {
    source = "./examples/branch-variations"

  }
}
run "branch_variations_rename_to_prod" {
  command   = apply
  state_key = "branch-variations"
  variables {
    default_branch = "prod"
  }

  module {
    source = "./examples/branch-variations"

  }
}

run "branch_variations_rename_to_main" {
  command   = apply
  state_key = "branch-variations"
  variables {
    default_branch = "main"
  }

  module {
    source = "./examples/branch-variations"

  }
}

