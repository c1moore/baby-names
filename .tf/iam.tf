resource "aws_iam_role" "dynamo-write-role" {
  name = "babynames-write"

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

resource "aws_iam_role_policy" "dynamo-write-policy" {
  name = "dynamo-write-policy"
  role = "${aws_iam_role.dynamo-write-role.id}"

  policy = <<-EOT
    {
      "Version":    "2012-10-17"
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
      "Version":    "2012-10-17"
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
