resource "aws_iam_role" "submit-guess-role" {
  name = "babynames-submit-role"

  assume_role_policy = <<-EOT
    {
      "Version":    "2012-10-17",
      "Statement":  [
        {
          "Action":     "sts:AssumeRole",
          "Principal":  {
            "Service":    "lambda.amazonaws.com"
          },
          "Effect":     "Allow",
          "Sid":        ""
        }
      ]
    }
    EOT
}

resource "aws_iam_role" "dynamo-read-role" {
  name = "babynames-read"

  assume_role_policy = <<-EOT
    {
      "Version":    "2012-10-17",
      "Statement":  [
        {
          "Action":     "sts:AssumeRole",
          "Principal":  {
            "Service":    "lambda.amazonaws.com"
          },
          "Effect":     "Allow",
          "Sid":        ""
        }
      ]
    }
    EOT
}

resource "aws_iam_role_policy" "ssm-read-policy" {
  name = "ssm-read-policy"
  role = "${aws_iam_role.submit-guess-role.id}"

  policy = <<-EOT
    {
      "Version":    "2012-10-17",
      "Statement":  [
        {
          "Resource": "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/BabyNames/production/*",
          "Effect":   "Allow",
          "Action":   [
            "ssm:GetParametersByPath",
            "ssm:GetParameters",
            "ssm:GetParameter"
          ]
        }
      ]
    }
    EOT
}

resource "aws_iam_role_policy" "log-policy" {
  name = "CloudWatchLog"
  role = "${aws_iam_role.submit-guess-role.id}"

  policy = <<-EOT
    {
      "Version":    "2012-10-17",
      "Statement":  [
        {
          "Action":   [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Effect":   "Allow",
          "Resource": "arn:aws:logs:*:*:*"
        }
      ]
    }
    EOT
}


resource "aws_iam_role_policy" "dynamo-write-policy" {
  name = "dynamo-write-policy"
  role = "${aws_iam_role.submit-guess-role.id}"

  policy = <<-EOT
    {
      "Version":    "2012-10-17",
      "Statement":  [
        {
          "Effect":   "Allow",
          "Action":   [
            "dynamodb:BatchWriteItem",
            "dynamodb:DeleteItem",
            "dynamodb:PutItem",
            "dynamodb:UpdateItem"
          ],
          "Resource": "${aws_dynamodb_table.db.arn}"
        }
      ]
    }
    EOT
}

resource "aws_iam_role_policy" "dynamo-read-policy" {
  name = "dynamo-read-policy"
  role = "${aws_iam_role.dynamo-read-role.id}"

  policy = <<-EOT
    {
      "Version":    "2012-10-17",
      "Statement":  [
        {
          "Effect":   "Allow",
          "Action":   [
            "dynamodb:BatchGetItem",
            "dynamodb:GetItem",
            "dynamodb:Query",
            "dynamodb:Scan"
          ],
          "Resource": "${aws_dynamodb_table.db.arn}"
        }
      ]
    }
    EOT
}

resource "aws_iam_policy" "s3-read-policy" {
  name        = "s3-policy"
  description = "Policy for allowing all S3 Actions"

  policy = <<-EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                  "s3:GetObject",
                  "s3:ListBucket"
                ],
                "Resource": "*"
            }
        ]
    }
    EOF
}

resource "aws_iam_role" "s3-api-gateyway-role" {
  name = "s3-api-gateyway-role"

  assume_role_policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "",
          "Effect": "Allow",
          "Principal": {
            "Service": "apigateway.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
      ]
    } 
    EOF
}

resource "aws_iam_role_policy_attachment" "s3-read-policy" {
  role       = "${aws_iam_role.s3-api-gateyway-role.name}"
  policy_arn = "${aws_iam_policy.s3-read-policy.arn}"
}
