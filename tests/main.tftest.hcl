

# provider "github" {
#   owner = "codelawcorp"
# }
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

run "no_template" {
  command   = apply
  state_key = "no_template"
  module {
    source = "./examples/no-template"
  }
}


run "branch_variations" {
  command   = apply
  state_key = "branch-variations"

  module {
    source = "./examples/branch-variations"

  }
}
