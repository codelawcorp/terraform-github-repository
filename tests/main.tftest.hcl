

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


run "chicken_egg" {
  command   = apply
  state_key = "chicken_egg"

  module {
    source = "./examples/chicken-egg"

  }
  variables {
    tf_cloud_token = null
  }
}
