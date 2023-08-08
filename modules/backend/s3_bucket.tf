resource "aws_s3_bucket" "files_bucket" {
  bucket        = var.bucket_name_save_users
  force_destroy = true
}


resource "aws_s3_bucket_versioning" "files_bucket_versioning" {
  bucket = aws_s3_bucket.files_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}