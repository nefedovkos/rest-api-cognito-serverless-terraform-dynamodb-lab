# create cognito user pool
resource "aws_cognito_user_pool" "user_pool" {
  name                     = var.user_pool_name
  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  username_configuration {
    case_sensitive = false
  }
  schema {
    attribute_data_type = "String"
    mutable             = true
    name                = "name"
    required            = true
  }
  schema {
    attribute_data_type = "String"
    mutable             = true
    name                = "email"
    required            = true
  }
  password_policy {
    minimum_length    = "8"
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }
  mfa_configuration = "OFF"
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }
  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
  }
  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  lambda_config {
    post_confirmation = var.lambda_auth_function_arn
  }

  lifecycle {
    ignore_changes = [schema]
  }
}


# create pool client
resource "aws_cognito_user_pool_client" "user_pool_client" {
  name                = var.user_pool_client_name
  user_pool_id        = aws_cognito_user_pool.user_pool.id
  generate_secret     = false
  explicit_auth_flows = ["ALLOW_CUSTOM_AUTH", "ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_PASSWORD_AUTH"]
  supported_identity_providers = [
    "COGNITO",
  ]


  callback_urls                        = [var.callback]
  allowed_oauth_flows                  = ["implicit", "code"]
  allowed_oauth_flows_user_pool_client = true
  #allowed_oauth_flows_user_pool        = true


  allowed_oauth_scopes = [
    "email",
    "openid",
    "aws.cognito.signin.user.admin",
  ]
}

# # create cognito user pool client
resource "aws_cognito_user_pool_domain" "user_pool_domain" {
  domain       = var.user_pool_domain_name
  user_pool_id = aws_cognito_user_pool.user_pool.id
}

resource "aws_cognito_resource_server" "resource_server" {

  user_pool_id = aws_cognito_user_pool.user_pool.id
  identifier   = "resource_server"
  name         = "resource_server"
  # scope {
  #   scope_name        = "scope"
  #   scope_description = "scope"
  # }
}

# create gui authentication
resource "aws_cognito_user_pool_ui_customization" "user_pool_ui_customization" {
  client_id    = aws_cognito_user_pool_client.user_pool_client.id
  css          = ".label-customizable {font-weight: 400;}"
  image_file   = filebase64("logo.png")
  user_pool_id = aws_cognito_user_pool_domain.user_pool_domain.user_pool_id
}


# create identity pool
resource "aws_cognito_identity_pool" "identity_pool" {
  identity_pool_name               = "identity_pool"
  allow_unauthenticated_identities = false
  allow_classic_flow               = false

  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.user_pool_client.id
    server_side_token_check = true
    provider_name           = "cognito-idp.${var.region}.amazonaws.com/${aws_cognito_user_pool.user_pool.id}"
  }

}






























