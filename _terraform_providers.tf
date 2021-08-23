terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    sumologic = {
      source = "SumoLogic/sumologic"
    }
  }
}

data "aws_caller_identity" "default" {}
data "aws_region" "default" {}
