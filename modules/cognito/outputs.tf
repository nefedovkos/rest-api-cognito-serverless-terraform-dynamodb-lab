output "cognito_user_pool_id" {
  value = aws_cognito_user_pool.user_pool.id
}
output "cognito_user_pool_arn" {
  value = aws_cognito_user_pool.user_pool.arn
}
output "user_pool_client_id" {
  value = aws_cognito_user_pool_client.user_pool_client.id
}

output "aws_cognito_token" {
  value = aws_cognito_user_pool_client.user_pool_client.id_token_validity
}


output "cognito_endpoint" {
  description = "The endpoint name of the user pool. Example format: cognito-idp.REGION.amazonaws.com/xxxx_yyyyy"
  value       = aws_cognito_user_pool.user_pool.endpoint
}

output "user_pool_domain_domain" {
  value = aws_cognito_user_pool_domain.user_pool_domain.domain
}

output "cognito_user_pool_client_id" {
  value = aws_cognito_user_pool_client.user_pool_client.id
}


output "callback_urls" {
  value = aws_cognito_user_pool_client.user_pool_client.callback_urls
}
