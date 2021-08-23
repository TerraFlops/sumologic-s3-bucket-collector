data "aws_caller_identity" "default" {}
data "aws_region" "default" {}

locals {
  name_snake = join("", [ for element in split("-",replace(var.name, "_", "-")): title(element) ])
}

# Create Sumo Logic role
resource "sumologic_role" "source" {
  name = local.name_snake
}

# Create IAM role that Sumo Logic will use the read the source bucket
resource "aws_iam_role" "source" {
  name = "SumoLogicS3Collector${local.name_snake}"
  assume_role_policy = data.aws_iam_policy_document.source_assume_role
}

# Allow SumoLogic to assume the IAM role
data "aws_iam_policy_document" "source_assume_role" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      identifiers = [
        "arn_aws_iam::926226587429:root"
      ]
      type = "AWS"
    }
  }
}

# Create IAM policy allowing access to read everything from the source bucket
data "aws_iam_policy_document" "source" {
  version = "2012-10-17"
  statement {
    actions = [
      "s3:Get*",
      "s3:Describe*",
      "s3:List*"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:s3:::${var.bucket_name}",
      "arn:aws:s3:::${var.bucket_name}/*"
    ]
  }
}

# Attach IAM policy to the user
resource "aws_iam_role_policy" "source" {
  name = "SumoLogicBucketCollector${local.name_snake}Policy"
  role = aws_iam_role.source.id
  policy = data.aws_iam_policy_document.source.json
}

# Create Sumo Logic collector for the S3 bucket
resource "sumologic_collector" "collector" {
  name = "TerraformS3Collector${data.aws_caller_identity.default.account_id}${local.name_snake}"
  description = "AWS S3 Bucket Collector (${local.name_snake})"
}

# Create Sumo Logic S3 bucket source
resource "sumologic_s3_source" "source" {
  name = "TerraformS3Source${data.aws_caller_identity.default.account_id}${local.name_snake}"
  description = "AWS S3 Bucket Source (${local.name_snake})"
  category = "aws/s3"
  content_type = "AwsS3Bucket"
  scan_interval = "2500"
  paused = false
  collector_id = sumologic_collector.collector.id
  # Use the IAM key/secret we created when reading the bucket
  authentication {
    type = "AWSRoleBasedAuthentication"
    role_arn = aws_iam_role.source.arn
  }
  # Specify the bucket/path we will be reading
  path {
    type = "S3BucketPathExpression"
    bucket_name = var.bucket_name
    path_expression = var.bucket_path_expression
  }
}
