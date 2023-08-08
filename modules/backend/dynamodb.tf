# create dynamodb table
resource "aws_dynamodb_table" "users" {
  name         = var.db_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "email"
  attribute {
    name = "email"
    type = "S"
  }
  lifecycle {
    prevent_destroy = false
  }
}



resource "aws_lambda_permission" "dynamodb_permission" {
  statement_id  = "AllowDynamoDBInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_auth_function_arn
  principal     = "dynamodb.amazonaws.com"
  source_arn    = aws_dynamodb_table.users.arn
}




