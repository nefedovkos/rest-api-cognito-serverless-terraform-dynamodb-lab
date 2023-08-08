variable "user_pool_name" {
  type        = string
  description = "The name of the user pool"
}
variable "user_pool_client_name" {
  type        = string
  description = "The name of the user pool client"
}
variable "callback" {
  type        = string
  description = "URL to callback after login"
  # default     = "https://www.google.com/"
}

variable "lambda_login_function_name" {
  type        = string
  description = "lambda_login_function_name"
}

variable "lambda_auth_function_name" {
  type        = string
  description = "lambda_auth_function_name"
}

variable "lambda_login_function_arn" {
  type        = string
  description = "lambda_login_function_arn"
}

variable "lambda_auth_function_arn" {
  type        = string
  description = "lambda_auth_function_arn"
}

variable "region" {
  type        = string
  description = "Region"
}
variable "user_pool_domain_name" {
  type        = string
  description = "The name of the domain user pool"
}
