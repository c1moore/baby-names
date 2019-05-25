resource "aws_api_gateway_rest_api" "baby-names-api" {
  name        = "BabyNamesAPI"
  description = "API for the baby names website."

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

resource "aws_api_gateway_integration" "s3-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id             = "${aws_api_gateway_resource.root-resource.id}"
  http_method             = "${aws_api_gateway_method.root-method.http_method}"
  integration_http_method = "GET"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.aws_region}:s3:path/${aws_s3_bucket.website.id}/index.html"
}


###############################
### API Resources
###############################
/**
 * POST /guesses
 */
resource "aws_api_gateway_resoure" "baby-names-guesses-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.baby-names-api.id}"
  parent_id   = "${aws_api_gateway_rest_api.baby-names-api.root_resource_id}"
  path_part   = "guesses"
}

resource "aws_api_gateway_method" "submit-guess-endpoint" {
  rest_api_id   = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id   = "${aws_api_gateway_resoure.baby-names-guesses-resource.id}"
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "submit-name-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id             = "${aws_api_gateway_resoure.baby-names-guesses-resource.id}"
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
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.baby-names-api.id}/*/${aws_api_gateway_method.submit-guess-endpoint.http_method}/${aws_api_gateway_resoure.baby-names-guesses-resource.path}"
}
