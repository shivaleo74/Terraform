terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.4.0"
    }
  }
}
#   backend "s3" {
#       skip_region_validation = true
#       bucket = "shivaleo-k8-terraforms"
#       key = "loops_statefile"
#       dynamodb_table = "shivaleo-k8-terraforms-lock"
#       # region = "ap-south-2"
#   }
# }

terraform {
  backend "s3" {
    bucket = "shivaleo-k8-terraforms"
    key    = "loops_statefile"
    dynamodb_table = "shivaleo-k8-terraforms-lock"
    region = "ap-south-1"
  }
}

provider "aws" {
  region = "ap-south-1"
}