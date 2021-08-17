locals {
  project_id = "joe-quickstart-gcp"
}

provider "google" {
  project = local.project_id
  region  = "us-east1"
  zone    = "us-east1-b"
}

resource "google_project_service" "compute_service" {
  project = local.project_id
  service = "compute.googleapis.com"
}





