provider "aws" {
  region = "${var.aws_region}"
}

variable "environment" {
  default = "production"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "cert_path" {
  default = "../.certs/live/baby-names.c1moore.codes"
}


data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
