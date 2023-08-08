variable "db_name" {
  type        = string
  description = "Name of dynamodb table of users"
}

variable "bucket_name_save_users" {
  type        = string
  description = "bucket_name_save_users"
}
variable "lambda_auth_function_arn" {
  type        = string
  description = "lambda_auth_function_arn"
}
