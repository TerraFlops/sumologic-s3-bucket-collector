variable "name" {
  type = string
  description = "Name of the SumoLogic S3 bucket collector"
}

variable "bucket_name" {
  type = string
  description = "Name of the S3 bucket containing logs to be exported to Sumo Logic"
}

variable "bucket_path_expression" {
  type = string
  description = "The S3 path to inspect. Defaults to '*'"
  default = "*"
}

variable "scan_interval" {
  type = number
  description = "The number of milliseconds between scans for new data in the bucket. Defaults to 5000 milliseconds"
  default = 5000
}

