resource "aws_dynamodb_table" "db" {
  name         = "Guesses"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "Guessor"

  attribute {
    name = "Guessor"
    type = "S"
  }

  ttl {
    attribute_name = "TTL"
    enabled        = false
  }

  timeouts {
    create = 1
    update = 1
    delete = 1
  }

  tags {
    Name        = "babynames-db"
    Project     = "BabyNames"
    Environment = "production"
    Provisioner = "terraform"
    Expiration  = "2019-09-02"
  }
}
