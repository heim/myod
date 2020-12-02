provider "google" {
  version = "~> 2.7.0"
  project = var.google_project_id
}

variable "google_project_id" {
  default = "<your-project-id-here>"
  type = string
}


