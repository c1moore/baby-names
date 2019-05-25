resource "aws_lambda_function" "submit-name" {
  function_name = "submit-name"
  description   = "Submit a guess for our baby's name."

  runtime   = "nodejs10.x"
  s3_bucket = "babynames-lambdas"
  s3_key    = "submit-name.zip"
  handler   = "exports.submitName"
  role      = "${aws_iam_role.dynamo-write-role.arn}"

  tags {
    Name        = "submit-name"
    Project     = "BabyNames"
    Environment = "production"
    Provisioner = "terraform"
    Expiration  = "2019-09-02"
  }

  environment {
    variables = {
      NODE_ENV          = "${var.environment}"
      AWS_REGION        = "${var.aws_region}"
      DYNAMO_TABLE_NAME = "${aws_dynamodb_table.db.id}"
    }
  }
}

resource "aws_lambda_function" "fetch-guesses" {
  function_name = "fetch-guesses"
  description   = "Calculates and returns the results."

  runtime   = "nodejs10.x"
  s3_bucket = "babynames-lambdas"
  s3_key    = "fetch-guesses.zip"
  handler   = "exports.calculateResults"
  role      = "${aws_iam_role.dynamo-read-role.arn}"

  tags {
    Name        = "fetch-guesses"
    Project     = "BabyNames"
    Environment = "production"
    Provisioner = "terraform"
    Expiration  = "2019-09-02"
  }

  environment {
    variables = {
      NODE_ENV          = "${var.environment}"
      AWS_REGION        = "${var.aws_region}"
      DYNAMO_TABLE_NAME = "${aws_dynamodb_table.db.id}"
    }
  }
}

resource "aws_lambda_function" "fetch-user-guesses" {
  function_name = "fetch-user-guesses"
  description   = "Fetches the guesses for a specific user."

  runtime   = "nodejs10.x"
  s3_bucket = "babynames-lambdas"
  s3_key    = "fetch-user-guesses.zip"
  handler   = "exports.fetchGuessesByUser"
  role      = "${aws_iam_role.dynamo-read-role.arn}"

  tags {
    Name        = "fetch-user-guesses"
    Project     = "BabyNames"
    Environment = "production"
    Provisioner = "terraform"
    Expiration  = "2019-09-02"
  }

  environment {
    variables = {
      NODE_ENV          = "${var.environment}"
      AWS_REGION        = "${var.aws_region}"
      DYNAMO_TABLE_NAME = "${aws_dynamodb_table.db.id}"
    }
  }
}
