
output "AWS_COGNITO_IDP_URI_TO_LOGIN" {
  # value = "Will add shortly"
  value = "https://${module.cognito.user_pool_domain_domain}.auth.${var.region}.amazoncognito.com/login?client_id=${module.cognito.cognito_user_pool_client_id}&response_type=token&scope=email+openid&redirect_uri=${module.api_gateway.rest_api_url}"
}
output "REST_API_URL" {
  value = module.api_gateway.rest_api_url
}


output "cognito_user_pool_id" {
  value = module.cognito.cognito_user_pool_id
}
output "cognito_client_id" {
  value = module.cognito.user_pool_client_id
}
