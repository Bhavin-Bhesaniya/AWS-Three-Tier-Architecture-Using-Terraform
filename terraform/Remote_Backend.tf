#create s3
resource "aws_s3_bucket" "terraform-statefile-bucket" {
  bucket = "terraform-statefile-s3bucket"
  tags = {
    Name = "terraform-state-file-s3bucket"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.terraform-statefile-bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "s3_file_versioning" {
  bucket = aws_s3_bucket.terraform-statefile-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_file_encryption" {
  bucket = aws_s3_bucket.terraform-statefile-bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#Create dynamodb
resource "aws_dynamodb_table" "dynamodb_statelock" {
  name         = "state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}