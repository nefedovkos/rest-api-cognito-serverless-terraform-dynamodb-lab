variable "region" {
  type        = string
  description = "The region in which to create/manage resources"
  default     = "us-east-1"
}
#TODO Add value of aws account_id
variable "account_id" {
  type        = string
  description = "The account ID in which to create/manage resources"
  default     = ""
}
variable "db_name" {
  type        = string
  description = "Name of dynamodb table of users"
  default     = "users"
}
variable "bucket_name_save_users" {
  type        = string
  description = "bucket_name_save_users"
  default     = "bucket-to-save-users-access"
}
variable "project_name" {
  type    = string
  default = "terraform-api-project"
}
variable "owner" {
  type    = string
  default = "Konstantin"
}
variable "lambda_login_function_name" {
  type    = string
  default = "lambda_login_function"
}
variable "lambda_auth_function_name" {
  type    = string
  default = "lambda_auth_function"
}



