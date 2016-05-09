resource "terraform_remote_state" "config" {
    backend = "s3"
    config {
        bucket = "epic-terraform-cluster-state"
        key = "softwaredev/terraform.tfstate"
        region = "eu-west-1"
    }
}