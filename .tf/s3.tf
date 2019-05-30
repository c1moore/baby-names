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
  etag   = "${filemd5("../build/public/index.html")}"

  tags = {
    Name        = "index.html"
    Project     = "BabyNames"
    Environment = "production"
    Provisioner = "terraform"
    Expiration  = "2019-09-02"
  }
}

resource "aws_s3_bucket_object" "main-js" {
  bucket = "${aws_s3_bucket.website.id}"
  key    = "main.49e0b43b82c6ec8de637.js"
  source = "../build/public/main.49e0b43b82c6ec8de637.js"
  etag   = "${filemd5("../build/public/main.49e0b43b82c6ec8de637.js")}"

  tags = {
    Name        = "main.js"
    Project     = "BabyNames"
    Environment = "production"
    Provisioner = "terraform"
    Expiration  = "2019-09-02"
  }
}

resource "aws_s3_bucket_object" "polyfills-js" {
  bucket = "${aws_s3_bucket.website.id}"
  key    = "polyfills.8bbb231b43165d65d357.js"
  source = "../build/public/polyfills.8bbb231b43165d65d357.js"
  etag   = "${filemd5("../build/public/polyfills.8bbb231b43165d65d357.js")}"

  tags = {
    Name        = "polyfills.js"
    Project     = "BabyNames"
    Environment = "production"
    Provisioner = "terraform"
    Expiration  = "2019-09-02"
  }
}

resource "aws_s3_bucket_object" "es2015-polyfills-js" {
  bucket = "${aws_s3_bucket.website.id}"
  key    = "es2015-polyfills.bda95d5896422d031328.js"
  source = "../build/public/es2015-polyfills.bda95d5896422d031328.js"
  etag   = "${filemd5("../build/public/es2015-polyfills.bda95d5896422d031328.js")}"

  tags = {
    Name        = "es2015-polyfills.js"
    Project     = "BabyNames"
    Environment = "production"
    Provisioner = "terraform"
    Expiration  = "2019-09-02"
  }
}

resource "aws_s3_bucket_object" "runtime-js" {
  bucket = "${aws_s3_bucket.website.id}"
  key    = "runtime.26209474bfa8dc87a77c.js"
  source = "../build/public/runtime.26209474bfa8dc87a77c.js"
  etag   = "${filemd5("../build/public/runtime.26209474bfa8dc87a77c.js")}"

  tags = {
    Name        = "runtime.js"
    Project     = "BabyNames"
    Environment = "production"
    Provisioner = "terraform"
    Expiration  = "2019-09-02"
  }
}

resource "aws_s3_bucket_object" "styles-css" {
  bucket = "${aws_s3_bucket.website.id}"
  key    = "styles.8a4940b7789650016df7.css"
  source = "../build/public/styles.8a4940b7789650016df7.css"
  etag   = "${filemd5("../build/public/styles.8a4940b7789650016df7.css")}"

  tags = {
    Name        = "styles.css"
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
  key    = "submit-guess.zip"
  source = "../build/services/submit-guess.zip"
  etag   = "${filemd5("../build/services/submit-guess.zip")}"

  tags = {
    Name        = "submit-guess.zip"
    Project     = "BabyNames"
    Environment = "production"
    Provisioner = "terraform"
    Expiration  = "2019-09-02"
  }
}

resource "aws_s3_bucket_object" "fetch-guesses" {
  bucket = "${aws_s3_bucket.website.id}"
  key    = "list-guesses.zip"
  source = "../build/services/list-guesses.zip"
  etag   = "${filemd5("../build/services/list-guesses.zip")}"

  tags = {
    Name        = "list-guesses.zip"
    Project     = "BabyNames"
    Environment = "production"
    Provisioner = "terraform"
    Expiration  = "2019-09-02"
  }
}

resource "aws_s3_bucket_object" "fetch-user-guesses" {
  bucket = "${aws_s3_bucket.website.id}"
  key    = "list-user-guesses.zip"
  source = "../build/services/list-user-guesses.zip"
  etag   = "${filemd5("../build/services/list-user-guesses.zip")}"

  tags = {
    Name        = "list-user-guesses.zip"
    Project     = "BabyNames"
    Environment = "production"
    Provisioner = "terraform"
    Expiration  = "2019-09-02"
  }
}