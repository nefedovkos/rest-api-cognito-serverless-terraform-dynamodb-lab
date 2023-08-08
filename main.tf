module "lambda_function" {
  source                     = "./modules/lambda_function"
  s3_bucket_files_bucket_arn = module.backend.s3_bucket_files_bucket_arn
  s3_bucket_name             = "project-terraform-api-gateway"
  project_name               = var.project_name
  owner                      = var.owner
  lambda_login_function_name = var.lambda_login_function_name
  lambda_auth_function_name  = var.lambda_auth_function_name
  bucket_name_save_users     = var.bucket_name_save_users
  cognito_user_pool_arn      = module.cognito.cognito_user_pool_arn
}
module "cognito" {
  source = "./modules/cognito"
  region = var.region
  # callback = module.api_gateway.rest_api_url
  callback              = "https://www.google.com/"
  user_pool_name        = "terraform-api-gateway-user-pool"
  user_pool_client_name = "terraform-api-gateway-pool-client"
  # lambda_function_arn           = module.lambda_function.lambda_function_arn
  user_pool_domain_name      = "devops"
  lambda_login_function_name = var.lambda_login_function_name
  lambda_login_function_arn  = module.lambda_function.lambda_login_function_arn
  lambda_auth_function_name  = var.lambda_auth_function_name
  lambda_auth_function_arn   = module.lambda_function.lambda_auth_function_arn
}
module "api_gateway" {
  source                           = "./modules/api_gateway"
  api_gateway_region               = var.region
  api_gateway_account_id           = var.account_id
  lambda_login_function_name       = var.lambda_login_function_name
  lambda_login_function_arn        = module.lambda_function.lambda_login_function_arn
  lambda_login_function_invoke_arn = module.lambda_function.lambda_login_function_invoke_arn
  lambda_auth_function_name        = var.lambda_auth_function_name
  lambda_auth_function_arn         = module.lambda_function.lambda_auth_function_arn
  lambda_auth_function_invoke_arn  = module.lambda_function.lambda_auth_function_invoke_arn
  cognito_user_pool_arn            = module.cognito.cognito_user_pool_arn
  rest_api_name                    = "terraform-api-gateway-project"
  rest_api_stage_name              = "developers"
  root_domain                      = "example.com"
  subdomain                        = "api.example.com"


  depends_on = [
    module.lambda_function
  ]
}

module "backend" {
  source                   = "./modules/backend"
  db_name                  = var.db_name
  bucket_name_save_users   = var.bucket_name_save_users
  lambda_auth_function_arn = module.lambda_function.lambda_auth_function_arn
}

