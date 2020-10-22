output "sumologic_collector_id" {
  description = "The ID of the Sumo Logic collector"
  value = sumologic_collector.collector.id
}

output "iam_user_arn" {
  description = "The IAM user that is created allowing Sumo Logic to read the S3 bucket"
  value = aws_iam_user.source.arn
}

output "iam_user_access_key_id" {
  description = "The IAM users AWS access key ID"
  value = aws_iam_access_key.source.id
}

output "iam_user_access_key_secret" {
  description = "The IAM users AWS access key secret"
  value = aws_iam_access_key.source.secret
}
