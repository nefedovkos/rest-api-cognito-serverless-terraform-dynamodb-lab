# using archive_file data source to zip the lambda code:
data "archive_file" "lambda_login" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_login"
  output_path = "${path.module}/lambda_login.zip"
}
data "archive_file" "lambda_auth" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_auth"
  output_path = "${path.module}/lambda_auth.zip"
}
# create s3 bucket
resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = var.s3_bucket_name
  force_destroy = true
}

# upload lambda function to the s3 bucket
resource "aws_s3_object" "lambda_login" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "lambda_login.zip"
  source = data.archive_file.lambda_login.output_path
  etag   = filemd5(data.archive_file.lambda_login.output_path) // check if code archive is latest version
}
resource "aws_s3_object" "lambda_auth" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "lambda_auth.zip"
  source = data.archive_file.lambda_auth.output_path
  etag   = filemd5(data.archive_file.lambda_auth.output_path) // check if code archive is latest version
}


############################
## lambda configuration
############################
# create lambda function
resource "aws_lambda_function" "lambda_function_login" {
  function_name    = var.lambda_login_function_name
  description      = "Lambda function used when user is login"
  s3_bucket        = aws_s3_bucket.lambda_bucket.id
  s3_key           = aws_s3_object.lambda_login.key
  runtime          = "nodejs14.x"
  handler          = "index.handler"
  source_code_hash = data.archive_file.lambda_login.output_base64sha256
  role             = aws_iam_role.lambda_login_execution_role.arn

  #TODO    add vpc endpoint
  # vpc_config {
  #   security_group_ids = var.security_group_ids
  #   subnet_ids         = var.subnet_ids
  # }
}
resource "aws_lambda_function" "lambda_function_auth" {
  function_name    = var.lambda_auth_function_name
  description      = "Lambda function used when user pass authentication"
  s3_bucket        = aws_s3_bucket.lambda_bucket.id
  s3_key           = aws_s3_object.lambda_auth.key
  runtime          = "nodejs14.x"
  handler          = "index.handler"
  source_code_hash = data.archive_file.lambda_auth.output_base64sha256
  role             = aws_iam_role.lambda_auth_execution_role.arn
}


# create cloudewatch logs
resource "aws_cloudwatch_log_group" "lambda_log_login_group" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_function_login.function_name}"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "lambda_log_auth_group" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_function_auth.function_name}"
  retention_in_days = 30
}

# create lambda login iam role
resource "aws_iam_role" "lambda_login_execution_role" {
  name = "lambda_login_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

# create lambda auth iam role
resource "aws_iam_role" "lambda_auth_execution_role" {
  name = "lambda_auth_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = [
            "lambda.amazonaws.com",
            "apigateway.amazonaws.com",
            "cognito-idp.amazonaws.com",
          ]
        }
      }
    ]
  })
}
# create lambda login policy
resource "aws_iam_policy" "lambda_login_policy" {
  name        = "lambda_login_policy"
  description = "My login policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:PutObjectAcl"
        ],
        "Resource" : [
          "arn:aws:s3:::${var.bucket_name_save_users}/*",
          "arn:aws:s3:::${var.bucket_name_save_users}"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : "ssm:GetParameter",
        "Resource" : "*"
      }
    ]
  })
}


# create lambda auth policy
resource "aws_iam_policy" "lambda_auth_policy" {
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "SpecificTable",
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:PutItem"
        ],
        "Resource" : "arn:aws:dynamodb:*:*:table/users"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ssm:PutParameter"
        ],
        "Resource" : "*"
      }
    ]
  })
}




# attach policy to the role
resource "aws_iam_role_policy_attachment" "lambda_login_policy" {
  role       = aws_iam_role.lambda_login_execution_role.name
  policy_arn = aws_iam_policy.lambda_login_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_auth_policy" {
  role       = aws_iam_role.lambda_auth_execution_role.name
  policy_arn = aws_iam_policy.lambda_auth_policy.arn
}


resource "aws_lambda_permission" "auth_permission" {
  statement_id  = "AllowExecutionFromCognito"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function_auth.function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = var.cognito_user_pool_arn
}

resource "aws_lambda_permission" "login_permission" {
  statement_id  = "AllowExecutionFromCognito"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function_login.function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = var.cognito_user_pool_arn
}