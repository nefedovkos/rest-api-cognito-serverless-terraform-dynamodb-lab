variable "rest_api_name" {
  type        = string
  description = "Name of the API Gateway"
}

variable "rest_api_stage_name" {
  type        = string
  description = "The name of the API Gateway stage"
}
variable "root_domain" {
  type        = string
  description = "The domain name to associate with the API"
}
variable "subdomain" {
  type        = string
  description = "The subdomain for the API"
}
variable "api_gateway_region" {
  type        = string
  description = "The region in which to create/manage resources"
} //value comes from main.tf
variable "api_gateway_account_id" {
  type        = string
  description = "The account ID in which to create/manage resources"
} //value comes from main.tf
variable "lambda_login_function_name" {
  type        = string
  description = "lambda_login_function_name"
} //value comes from main.tf
variable "lambda_login_function_arn" {
  type        = string
  description = "lambda_login_function_arn"
} //value comes from main.tf
variable "lambda_login_function_invoke_arn" {
  type        = string
  description = "lambda_login_function_invoke_arn"
} //value comes from main.tf
variable "lambda_auth_function_name" {
  type        = string
  description = "lambda_auth_function_name"
} //value comes from main.tf
variable "lambda_auth_function_arn" {
  type        = string
  description = "lambda_auth_function_arn"
} //value comes from main.tf

variable "lambda_auth_function_invoke_arn" {
  type        = string
  description = "lambda_auth_function_invoke_arn"
} //value comes from main.tf

variable "cognito_user_pool_arn" {
  type        = string
  description = "The ARN of the user pool"
} //value comes from main.tf