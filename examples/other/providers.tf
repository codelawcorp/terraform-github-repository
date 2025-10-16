terraform {
  required_version = "~> 1.0"
  required_providers {
    github = {
      source  = "hashicorp/github"
      version = ">= 6.6, <7.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0, <5.0"
    }
  }
}

# export GITHUB_OWNER=codelawcorp
