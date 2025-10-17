terraform {
  required_version = "~> 1.0"
  required_providers {
    github = {
      source  = "hashicorp/github"
      version = ">= 6.6, <7.0"
    }
    tfe = {
      source = "hashicorp/tfe"
    version = ">= 0.70, <1.0" }
  }
}

