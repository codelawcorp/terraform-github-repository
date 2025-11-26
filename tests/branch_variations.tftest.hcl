
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

run "branch_variations_main_retry" { # Just re-run it, because module behaves differently on the first apply
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
  assert {
    condition     = module.branch_variation_listed_default_branch.branch_default == "prod"
    error_message = "Default branch did not match expected"
  }
}