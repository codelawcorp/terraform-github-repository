
# ---
resource "github_repository_file" "backend" {
  count      = var.bootstrap_tf_cloud != null ? 1 : 0
  repository = github_repository.this.name
  file       = "backend.tf"
  content = templatefile("${path.module}/assets/backend.tf.tpl", {
    tf_cloud_organization = try(var.bootstrap_tf_cloud.tf_cloud_organization, null)
    tf_cloud_workspace    = try(var.bootstrap_tf_cloud.tf_cloud_workspace, null)
  })
  branch              = local.default_branch
  commit_message      = "feat: added tf backend"
  overwrite_on_create = false

  depends_on = [github_branch.this]
}

resource "github_repository_file" "gha" {
  count               = var.bootstrap_tf_cloud != null ? 1 : 0
  repository          = github_repository.this.name
  file                = ".github/workflows/main.yaml"
  content             = file("${path.module}/assets/gha.yaml")
  branch              = local.default_branch
  commit_message      = "ci: configured gha"
  overwrite_on_create = false

  depends_on = [
    github_branch.this,
    github_repository_file.backend
  ]
  lifecycle {
    ignore_changes = [content] # Allows user to modify the file after the inital bootstrapping.
  }
}
resource "github_repository_file" "release_rc" {
  count               = var.bootstrap_tf_cloud != null ? 1 : 0
  repository          = github_repository.this.name
  file                = ".releaserc.yaml"
  content             = file("${path.module}/assets/releaserc.yaml")
  branch              = local.default_branch
  commit_message      = "ci: configured semantic-release tool"
  overwrite_on_create = false

  depends_on = [
    github_branch.this,
    github_repository_file.backend
  ]
  lifecycle {
    ignore_changes = [content] # Allows user to modify the file after the inital bootstrapping.
  }
}

resource "github_repository_file" "gitignore" {
  count               = var.bootstrap_tf_cloud != null ? 1 : 0
  repository          = github_repository.this.name
  file                = ".gitignore"
  content             = file("${(path.module)}/assets/gitignore")
  branch              = local.default_branch
  commit_message      = "chore: configured .gitignore"
  overwrite_on_create = false

  depends_on = [
    github_branch.this
  ]

  lifecycle {
    ignore_changes = [content] # Allows user to modify the file after the inital bootstrapping.
  }
}

resource "github_repository_file" "tf_version" { # This file is used by tfenv
  count               = var.bootstrap_tf_cloud != null ? 1 : 0
  repository          = github_repository.this.name
  file                = ".terraform-version"
  content             = try(var.bootstrap_tf_cloud.terraform_version, "latest")
  branch              = local.default_branch
  commit_message      = "chore: specified terraform version"
  overwrite_on_create = false

  depends_on = [
    github_branch.this
  ]
}

resource "github_actions_variable" "tf_version" {
  count         = var.bootstrap_tf_cloud != null ? 1 : 0
  repository    = github_repository.this.name
  variable_name = "TERRAFORM_VERSION"
  value         = try(var.bootstrap_tf_cloud.terraform_version, "latest")
}

resource "github_actions_secret" "tfe_token" {
  count           = var.bootstrap_tf_cloud != null ? 1 : 0
  repository      = github_repository.this.name
  secret_name     = "TF_TOKEN_APP_TERRAFORM_IO"
  plaintext_value = var.bootstrap_tf_cloud.tfe_token
  lifecycle {
    ignore_changes = [plaintext_value] # Prevents leaking the secret value in plan
  }
}

# resource "git_init" "this" {
#   directory = abspath(path.root)
# }

# resource "git_remote" "this" {
#   directory = abspath(path.root)
#   name      = "origin"
#   urls      = [github_repository.this.http_clone_url]

#   depends_on = [ git_init.this, github_repository.this]
# }


resource "terraform_data" "this" {
  count = var.bootstrap_tf_cloud != null ? 1 : 0
  input = github_repository.this.http_clone_url
  # triggers_replace = [github_repository.this.http_clone_url]

  lifecycle {
    replace_triggered_by = [
      github_repository.this.http_clone_url,
    ]
  }
  provisioner "local-exec" {
    when        = create
    on_failure  = fail
    interpreter = ["bash", "-c"]
    # This is required for terraform tests to work properly and also is an appropriate destroy action often.
    command = <<EOL
set -e
cd ${abspath(path.root)} 
 
  git init --initial-branch ${local.default_branch} 
  git config url."https://x-access-token:${var.bootstrap_tf_cloud.github_token}@github.com/${github_repository.this.full_name}".insteadOf "https://github.com/${github_repository.this.full_name}" 
  git remote add origin ${self.input}  
  git fetch origin 
  (git branch --set-upstream-to origin/${local.default_branch} ${local.default_branch} || (git reset --hard origin/${local.default_branch}  && git branch --set-upstream-to origin/${local.default_branch} ${local.default_branch} )) 
  git remote set-head origin -a 
  (git add main.tf  && git commit -m 'feat: bootstrap bootstrap commit' && git push || true ) 
EOL
  }

  provisioner "local-exec" { # This does not work as expected with remote runner
    when        = destroy
    on_failure  = fail
    interpreter = ["bash", "-c"]
    command     = " cd ${abspath(path.root)} && rm -rf .git" # This is required for terraform tests to work properly and also is an appropriate destroy action often.
  }
  depends_on = [
    github_repository_file.backend,
    github_repository_file.gitignore,
    github_repository_file.gha,
    github_repository_file.release_rc,
    github_repository_file.tf_version
  ] # Just to be sure that repo is initialized, branch is updated


}

data "tfe_workspace" "this" {
  count        = var.bootstrap_tf_cloud != null ? 1 : 0
  name         = var.bootstrap_tf_cloud.tf_cloud_workspace
  organization = var.bootstrap_tf_cloud.tf_cloud_organization
}

resource "tfe_variable" "github_token_env" {
  count        = var.bootstrap_tf_cloud != null ? 1 : 0
  key          = "GITHUB_TOKEN"
  value        = var.bootstrap_tf_cloud.github_token
  category     = "env"
  workspace_id = data.tfe_workspace.this[0].id
  description  = "A token with repo permissions"
}

resource "tfe_variable" "github_token" {
  count        = var.bootstrap_tf_cloud != null ? 1 : 0
  key          = "github_token"
  value        = var.bootstrap_tf_cloud.github_token
  category     = "terraform"
  workspace_id = data.tfe_workspace.this[0].id
  description  = "A token with repo permissions"
}

resource "tfe_variable" "tfe_token_env" {
  count        = var.bootstrap_tf_cloud != null ? 1 : 0
  key          = "TFE_TOKEN"
  value        = var.bootstrap_tf_cloud.tfe_token
  category     = "env"
  workspace_id = data.tfe_workspace.this[0].id
  sensitive    = true
  description  = "This token is to be used by tfe runner, this should have elevated privileges to manage this tfe organization. "
}


resource "tfe_variable" "tfe_token" {
  count        = var.bootstrap_tf_cloud != null ? 1 : 0
  key          = "tfe_token"
  value        = var.bootstrap_tf_cloud.tfe_token
  category     = "terraform"
  workspace_id = data.tfe_workspace.this[0].id
  sensitive    = true
  description  = "This token is to be used by tfe runner, this should have elevated privileges to manage this tfe organization. "
}


