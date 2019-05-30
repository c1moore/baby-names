resource "aws_api_gateway_rest_api" "baby-names-api" {
  name        = "BabyNamesAPI"
  description = "API for the baby names website."

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_domain_name" "main" {
  domain_name = "baby-names.c1moore.codes"

  regional_certificate_name = "baby-names-cert"
  certificate_body          = "${file("${var.cert_path}/cert.pem")}"
  certificate_chain         = "${file("${var.cert_path}/fullchain.pem")}"
  certificate_private_key   = "${file("${var.cert_path}/privkey.pem")}"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}


###############################
### Static Website Resources
###############################
/**
 * index.html
 */
resource "aws_api_gateway_resource" "root-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.baby-names-api.id}"
  parent_id   = "${aws_api_gateway_rest_api.baby-names-api.root_resource_id}"
  path_part   = "/"
}

resource "aws_api_gateway_method" "root-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id   = "${aws_api_gateway_resource.root-resource.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "index-html" {
  rest_api_id             = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id             = "${aws_api_gateway_resource.root-resource.id}"
  http_method             = "${aws_api_gateway_method.root-method.http_method}"
  integration_http_method = "GET"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.aws_region}:s3:path/${aws_s3_bucket.website.id}/${aws_s3_bucket_object.index.id}"
}

resource "aws_api_gateway_integration_response" "index-html-res" {
  rest_api_id = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id = "${aws_api_gateway_resource.root-resource.id}"
  http_method = "${aws_api_gateway_method.root-method.http_method}"
  status_code = 200

  response_parameters = {
    "method.response.header.Content-Type" = "'text/html'"
  }
}

resource "aws_api_gateway_resource" "main-js-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.baby-names-api.id}"
  parent_id   = "${aws_api_gateway_rest_api.baby-names-api.root_resource_id}"
  path_part   = "/${aws_s3_bucket_object.main-js.id}"
}

resource "aws_api_gateway_method" "main-js-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id   = "${aws_api_gateway_resource.main-js-resource.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "main-js" {
  rest_api_id             = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id             = "${aws_api_gateway_resource.main-js-resource.id}"
  http_method             = "${aws_api_gateway_method.main-js-method.http_method}"
  integration_http_method = "GET"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.aws_region}:s3:path/${aws_s3_bucket.website.id}/${aws_s3_bucket_object.main-js.id}"
}

resource "aws_api_gateway_integration_response" "main-js-res" {
  rest_api_id = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id = "${aws_api_gateway_resource.main-js-resource.id}"
  http_method = "${aws_api_gateway_method.main-js-method.http_method}"
  status_code = 200

  response_parameters = {
    "method.response.header.Content-Type" = "'text/javascript'"
  }
}

resource "aws_api_gateway_resource" "polyfills-js-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.baby-names-api.id}"
  parent_id   = "${aws_api_gateway_rest_api.baby-names-api.root_resource_id}"
  path_part   = "/${aws_s3_bucket_object.polyfills-js.id}"
}

resource "aws_api_gateway_method" "polyfills-js-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id   = "${aws_api_gateway_resource.polyfills-js-resource.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "polyfills-js" {
  rest_api_id             = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id             = "${aws_api_gateway_resource.polyfills-js-resource.id}"
  http_method             = "${aws_api_gateway_method.polyfills-js-method.http_method}"
  integration_http_method = "GET"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.aws_region}:s3:path/${aws_s3_bucket.website.id}/${aws_s3_bucket_object.polyfills-js.id}"
}

resource "aws_api_gateway_integration_response" "polyfills-js-res" {
  rest_api_id = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id = "${aws_api_gateway_resource.polyfills-js-resource.id}"
  http_method = "${aws_api_gateway_method.polyfills-js-method.http_method}"
  status_code = 200

  response_parameters = {
    "method.response.header.Content-Type" = "'text/javascript'"
  }
}

resource "aws_api_gateway_resource" "es2015-polyfills-js-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.baby-names-api.id}"
  parent_id   = "${aws_api_gateway_rest_api.baby-names-api.root_resource_id}"
  path_part   = "/${aws_s3_bucket_object.es2015-polyfills-js.id}"
}

resource "aws_api_gateway_method" "es2015-polyfills-js-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id   = "${aws_api_gateway_resource.es2015-polyfills-js-resource.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "es2015-polyfills-js" {
  rest_api_id             = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id             = "${aws_api_gateway_resource.es2015-polyfills-js-resource.id}"
  http_method             = "${aws_api_gateway_method.es2015-polyfills-js-method.http_method}"
  integration_http_method = "GET"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.aws_region}:s3:path/${aws_s3_bucket.website.id}/${aws_s3_bucket_object.es2015-polyfills-js.id}"
}

resource "aws_api_gateway_integration_response" "es2015-polyfills-js-res" {
  rest_api_id = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id = "${aws_api_gateway_resource.es2015-polyfills-js-resource.id}"
  http_method = "${aws_api_gateway_method.es2015-polyfills-js-method.http_method}"
  status_code = 200

  response_parameters = {
    "method.response.header.Content-Type" = "'text/javascript'"
  }
}

resource "aws_api_gateway_resource" "runtime-js-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.baby-names-api.id}"
  parent_id   = "${aws_api_gateway_rest_api.baby-names-api.root_resource_id}"
  path_part   = "/${aws_s3_bucket_object.runtime-js.id}"
}

resource "aws_api_gateway_method" "runtime-js-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id   = "${aws_api_gateway_resource.runtime-js-resource.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "runtime-js" {
  rest_api_id             = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id             = "${aws_api_gateway_resource.runtime-js-resource.id}"
  http_method             = "${aws_api_gateway_method.runtime-js-method.http_method}"
  integration_http_method = "GET"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.aws_region}:s3:path/${aws_s3_bucket.website.id}/${aws_s3_bucket_object.runtime-js.id}"
}

resource "aws_api_gateway_integration_response" "runtime-js-res" {
  rest_api_id = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id = "${aws_api_gateway_resource.runtime-js-resource.id}"
  http_method = "${aws_api_gateway_method.runtime-js-method.http_method}"
  status_code = 200

  response_parameters = {
    "method.response.header.Content-Type" = "'text/javascript'"
  }
}

resource "aws_api_gateway_resource" "styles-css-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.baby-names-api.id}"
  parent_id   = "${aws_api_gateway_rest_api.baby-names-api.root_resource_id}"
  path_part   = "/${aws_s3_bucket_object.styles-css.id}"
}

resource "aws_api_gateway_method" "styles-css-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id   = "${aws_api_gateway_resource.styles-css-resource.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "styles-css" {
  rest_api_id             = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id             = "${aws_api_gateway_resource.styles-css-resource.id}"
  http_method             = "${aws_api_gateway_method.styles-css-method.http_method}"
  integration_http_method = "GET"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.aws_region}:s3:path/${aws_s3_bucket.website.id}/${aws_s3_bucket_object.styles-css.id}"
}

resource "aws_api_gateway_integration_response" "styles-css-res" {
  rest_api_id = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id = "${aws_api_gateway_resource.styles-css-resource.id}"
  http_method = "${aws_api_gateway_method.styles-css-method.http_method}"
  status_code = 200

  response_parameters = {
    "method.response.header.Content-Type" = "'text/css'"
  }
}

###############################
### API Resources
###############################
/**
 * POST /guesses
 */
resource "aws_api_gateway_resource" "baby-names-guesses-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.baby-names-api.id}"
  parent_id   = "${aws_api_gateway_rest_api.baby-names-api.root_resource_id}"
  path_part   = "guesses"
}

resource "aws_api_gateway_method" "submit-guess-endpoint" {
  rest_api_id   = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id   = "${aws_api_gateway_resource.baby-names-guesses-resource.id}"
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "submit-name-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id             = "${aws_api_gateway_resource.baby-names-guesses-resource.id}"
  http_method             = "${aws_api_gateway_method.submit-guess-endpoint.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.submit-name.arn}/invocations"
}

resource "aws_lambda_permission" "apigateway-lambda-permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.submit-name.function_name}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.baby-names-api.id}/*/${aws_api_gateway_method.submit-guess-endpoint.http_method}/${aws_api_gateway_resource.baby-names-guesses-resource.path}"
}
