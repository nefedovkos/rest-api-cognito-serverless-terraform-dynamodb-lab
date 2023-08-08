
output "lambda_login_function_name" {
  value = aws_lambda_function.lambda_function_login.function_name
}

output "lambda_login_function_arn" {
  value = aws_lambda_function.lambda_function_login.arn
}
output "lambda_login_function_invoke_arn" {
  value = aws_lambda_function.lambda_function_login.invoke_arn
}
output "lambda_auth_function_name" {
  value = aws_lambda_function.lambda_function_auth.function_name
}

output "lambda_auth_function_arn" {
  value = aws_lambda_function.lambda_function_auth.arn
}
output "lambda_auth_function_invoke_arn" {
  value = aws_lambda_function.lambda_function_auth.invoke_arn
}