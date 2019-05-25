###############################
### Static Website Resources
###############################
resource "aws_s3_bucket" "website" {
  bucket = "baby-names.c1moore.codes"
  acl    = "public-read"

  website {
    index_document = "index.html"
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["*"]
    allowed_origins = ["*"]
  }
}

resource "aws_s3_bucket_object" "index" {
  bucket = "${aws_s3_bucket.website.id}"
  key    = "index.html"
  source = "../build/public/index.html"
  etag   = "${filemd5("../build/index.html")}"

  tags {
    Name        = "index.html"
    Project     = "BabyNames"
    Environment = "production"
    Provisioner = "terraform"
    Expiration  = "2019-09-02"
  }
}

###############################
### Lambda Resources
###############################
resource "aws_s3_bucket" "s3-lambdas" {
  bucket = "babynames-lambdas"
  acl    = "private"
}

resource "aws_s3_bucket_object" "submit-name" {
  bucket = "${aws_s3_bucket.website.id}"
  key    = "submit-name.zip"
  source = "../build/services/submit-name.zip"
  etag   = "${filemd5("../build/submit-name.zip")}"

  tags {
    Name        = "submit-name.zip"
    Project     = "BabyNames"
    Environment = "production"
    Provisioner = "terraform"
    Expiration  = "2019-09-02"
  }
}

resource "aws_s3_bucket_object" "fetch-guesses" {
  bucket = "${aws_s3_bucket.website.id}"
  key    = "fetch-guesses.zip"
  source = "../build/services/fetch-guesses.zip"
  etag   = "${filemd5("../build/fetch-guesses.zip")}"

  tags {
    Name        = "fetch-guesses.zip"
    Project     = "BabyNames"
    Environment = "production"
    Provisioner = "terraform"
    Expiration  = "2019-09-02"
  }
}

resource "aws_s3_bucket_object" "fetch-user-guesses" {
  bucket = "${aws_s3_bucket.website.id}"
  key    = "fetch-user-guesses.zip"
  source = "../build/services/fetch-user-guesses.zip"
  etag   = "${filemd5("../build/fetch-user-guesses.zip")}"

  tags {
    Name        = "fetch-user-guesses.zip"
    Project     = "BabyNames"
    Environment = "production"
    Provisioner = "terraform"
    Expiration  = "2019-09-02"
  }
}