resource "aws_api_gateway_rest_api" "baby-names-api" {
  name        = "BabyNamesAPI"
  description = "API for the baby names website."

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_domain_name" "main" {
  domain_name = "baby-names.c1moore.codes"

  regional_certificate_arn = "${file("${var.cert_path}/arn.pem")}"

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
resource "aws_api_gateway_method" "root-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id   = "${aws_api_gateway_rest_api.baby-names-api.root_resource_id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "index-html" {
  rest_api_id             = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id             = "${aws_api_gateway_rest_api.baby-names-api.root_resource_id}"
  http_method             = "${aws_api_gateway_method.root-method.http_method}"
  integration_http_method = "GET"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.aws_region}:s3:path/${aws_s3_bucket.website.id}/${aws_s3_bucket_object.index.id}"

  credentials = "${aws_iam_role.s3-api-gateyway-role.arn}"
}

resource "aws_api_gateway_method_response" "index-html-res-200" {
  depends_on = [
    aws_api_gateway_integration.index-html
  ]

  rest_api_id = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id = "${aws_api_gateway_rest_api.baby-names-api.root_resource_id}"
  http_method = "${aws_api_gateway_method.root-method.http_method}"
  status_code = 200

  response_parameters = {
    "method.response.header.Timestamp"      = true
    "method.response.header.Content-Length" = true
    "method.response.header.Content-Type"   = true
  }
}

resource "aws_api_gateway_integration_response" "index-html-res" {
  depends_on = [
    aws_api_gateway_integration.index-html,
    aws_api_gateway_method_response.index-html-res-200
  ]

  rest_api_id = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id = "${aws_api_gateway_rest_api.baby-names-api.root_resource_id}"
  http_method = "${aws_api_gateway_method.root-method.http_method}"
  status_code = 200

  response_parameters = {
    "method.response.header.Content-Type" = "'text/html'"
  }
}

resource "aws_api_gateway_resource" "main-js-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.baby-names-api.id}"
  parent_id   = "${aws_api_gateway_rest_api.baby-names-api.root_resource_id}"
  path_part   = "${aws_s3_bucket_object.main-js.id}"
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

  credentials = "${aws_iam_role.s3-api-gateyway-role.arn}"
}

resource "aws_api_gateway_method_response" "main-js-res-200" {
  depends_on = [aws_api_gateway_integration.main-js]

  rest_api_id = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id = "${aws_api_gateway_resource.main-js-resource.id}"
  http_method = "${aws_api_gateway_method.main-js-method.http_method}"
  status_code = 200

  response_parameters = {
    "method.response.header.Timestamp"      = true
    "method.response.header.Content-Length" = true
    "method.response.header.Content-Type"   = true
  }
}

resource "aws_api_gateway_integration_response" "main-js-res" {
  depends_on = [
    aws_api_gateway_integration.main-js,
    aws_api_gateway_method_response.main-js-res-200
  ]

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
  path_part   = "${aws_s3_bucket_object.polyfills-js.id}"
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

  credentials = "${aws_iam_role.s3-api-gateyway-role.arn}"
}

resource "aws_api_gateway_method_response" "polyfills-js-res-200" {
  depends_on = [aws_api_gateway_integration.polyfills-js]

  rest_api_id = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id = "${aws_api_gateway_resource.polyfills-js-resource.id}"
  http_method = "${aws_api_gateway_method.polyfills-js-method.http_method}"
  status_code = 200

  response_parameters = {
    "method.response.header.Timestamp"      = true
    "method.response.header.Content-Length" = true
    "method.response.header.Content-Type"   = true
  }
}

resource "aws_api_gateway_integration_response" "polyfills-js-res" {
  depends_on = [
    aws_api_gateway_integration.polyfills-js,
    aws_api_gateway_method_response.polyfills-js-res-200
  ]

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
  path_part   = "${aws_s3_bucket_object.es2015-polyfills-js.id}"
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

  credentials = "${aws_iam_role.s3-api-gateyway-role.arn}"
}

resource "aws_api_gateway_method_response" "es2015-polyfills-js-res-200" {
  depends_on = [aws_api_gateway_integration.es2015-polyfills-js]

  rest_api_id = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id = "${aws_api_gateway_resource.es2015-polyfills-js-resource.id}"
  http_method = "${aws_api_gateway_method.es2015-polyfills-js-method.http_method}"
  status_code = 200

  response_parameters = {
    "method.response.header.Timestamp"      = true
    "method.response.header.Content-Length" = true
    "method.response.header.Content-Type"   = true
  }
}

resource "aws_api_gateway_integration_response" "es2015-polyfills-js-res" {
  depends_on = [
    aws_api_gateway_integration.es2015-polyfills-js,
    aws_api_gateway_method_response.es2015-polyfills-js-res-200
  ]

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
  path_part   = "${aws_s3_bucket_object.runtime-js.id}"
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

  credentials = "${aws_iam_role.s3-api-gateyway-role.arn}"
}

resource "aws_api_gateway_method_response" "runtime-js-res-200" {
  depends_on = [aws_api_gateway_integration.runtime-js]

  rest_api_id = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id = "${aws_api_gateway_resource.runtime-js-resource.id}"
  http_method = "${aws_api_gateway_method.runtime-js-method.http_method}"
  status_code = 200

  response_parameters = {
    "method.response.header.Timestamp"      = true
    "method.response.header.Content-Length" = true
    "method.response.header.Content-Type"   = true
  }
}

resource "aws_api_gateway_integration_response" "runtime-js-res" {
  depends_on = [
    aws_api_gateway_integration.runtime-js,
    aws_api_gateway_method_response.runtime-js-res-200
  ]

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
  path_part   = "${aws_s3_bucket_object.styles-css.id}"
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

  credentials = "${aws_iam_role.s3-api-gateyway-role.arn}"
}

resource "aws_api_gateway_method_response" "styles-css-res-200" {
  depends_on = [aws_api_gateway_integration.styles-css]

  rest_api_id = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id = "${aws_api_gateway_resource.styles-css-resource.id}"
  http_method = "${aws_api_gateway_method.styles-css-method.http_method}"
  status_code = 200

  response_parameters = {
    "method.response.header.Timestamp"      = true
    "method.response.header.Content-Length" = true
    "method.response.header.Content-Type"   = true
  }
}


resource "aws_api_gateway_integration_response" "styles-css-res" {
  depends_on = [
    aws_api_gateway_integration.styles-css,
    aws_api_gateway_method_response.styles-css-res-200
  ]

  rest_api_id = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id = "${aws_api_gateway_resource.styles-css-resource.id}"
  http_method = "${aws_api_gateway_method.styles-css-method.http_method}"
  status_code = 200

  response_parameters = {
    "method.response.header.Content-Type"   = "'text/css'"
    "method.response.header.Timestamp"      = "integration.response.header.Date"
    "method.response.header.Content-Length" = "integration.response.header.Content-Length"
  }
}

###############################
### API Resources
###############################
/**
 * POST /guesses
 */
resource "aws_api_gateway_resource" "api-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.baby-names-api.id}"
  parent_id   = "${aws_api_gateway_rest_api.baby-names-api.root_resource_id}"
  path_part   = "guesses"
}

resource "aws_api_gateway_method" "submit-guess-endpoint" {
  rest_api_id   = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id   = "${aws_api_gateway_resource.api-resource.id}"
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "submit-guess-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id             = "${aws_api_gateway_resource.api-resource.id}"
  http_method             = "${aws_api_gateway_method.submit-guess-endpoint.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.submit-name.invoke_arn}"
}

resource "aws_lambda_permission" "apigateway-submit-guess-permission" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.submit-name.function_name}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.baby-names-api.execution_arn}/*/${aws_api_gateway_method.submit-guess-endpoint.http_method}${aws_api_gateway_resource.api-resource.path}"
}

/**
 * GET /guesses
 */
resource "aws_api_gateway_method" "list-guesses-endpoint" {
  rest_api_id   = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id   = "${aws_api_gateway_resource.api-resource.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "list-guesses-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id             = "${aws_api_gateway_resource.api-resource.id}"
  http_method             = "${aws_api_gateway_method.list-guesses-endpoint.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.fetch-guesses.invoke_arn}"
}

resource "aws_lambda_permission" "apigateway-list-guesses-permission" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.fetch-guesses.function_name}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.baby-names-api.execution_arn}/*/${aws_api_gateway_method.list-guesses-endpoint.http_method}${aws_api_gateway_resource.api-resource.path}"
}

/**
 * GET /guesses/{guessor}
 */
resource "aws_api_gateway_resource" "guessor-api-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.baby-names-api.id}"
  parent_id   = "${aws_api_gateway_resource.api-resource.id}"
  path_part   = "{guessor}"
}

resource "aws_api_gateway_method" "list-user-guesses-endpoint" {
  rest_api_id   = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id   = "${aws_api_gateway_resource.guessor-api-resource.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "list-user-guesses-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.baby-names-api.id}"
  resource_id             = "${aws_api_gateway_resource.guessor-api-resource.id}"
  http_method             = "${aws_api_gateway_method.list-user-guesses-endpoint.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.fetch-user-guesses.invoke_arn}"
}

resource "aws_lambda_permission" "apigateway-lambda-permission" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.fetch-user-guesses.function_name}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.baby-names-api.execution_arn}/*/${aws_api_gateway_method.list-user-guesses-endpoint.http_method}${aws_api_gateway_resource.guessor-api-resource.path}"
}

resource "aws_api_gateway_deployment" "prod-deploy" {
  depends_on = [
    aws_api_gateway_integration.index-html,
    aws_api_gateway_integration.main-js,
    aws_api_gateway_integration.polyfills-js,
    aws_api_gateway_integration.es2015-polyfills-js,
    aws_api_gateway_integration.runtime-js,
    aws_api_gateway_integration.styles-css,
    aws_api_gateway_integration.submit-guess-integration,
    aws_api_gateway_integration.list-guesses-integration,
    aws_api_gateway_integration.list-user-guesses-integration
  ]

  rest_api_id = "${aws_api_gateway_rest_api.baby-names-api.id}"
  stage_name  = "prod"
}
