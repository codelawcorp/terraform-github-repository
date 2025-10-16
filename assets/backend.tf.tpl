terraform {
  cloud {
    organization = "${tf_cloud_organization}"

    workspaces {
      name = "${tf_cloud_workspace}"
    }
  }
}