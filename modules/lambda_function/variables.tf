variable "s3_bucket_name" {
  type        = string
  description = "The name of the S3 bucket to store the Lambda function code"
}


variable "project_name" {
  type        = string
  description = "The name of the project"
}

variable "owner" {
  type        = string
  description = "Project owners"
}


variable "s3_bucket_files_bucket_arn" {
  type        = string
  description = "s3_bucket_files_bucket_arn"
}

variable "lambda_login_function_name" {
  type        = string
  description = "lambda_login_function_name"
}


variable "lambda_auth_function_name" {
  type        = string
  description = "lambda_auth_function_name"
}
variable "cognito_user_pool_arn" {
  type        = string
  description = "cognito_user_pool_arn"
}

variable "bucket_name_save_users" {
  type        = string
  description = "bucket_name_save_users"
}