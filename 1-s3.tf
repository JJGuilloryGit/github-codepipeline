#1. ######Creation of Bucket########

resource "aws_s3_bucket" "bucket" {
  bucket = "s3-bucket-for-class-uv"

}


#2. ###Static Website Config#######

resource "aws_s3_bucket_website_configuration" "site" {
  bucket = aws_s3_bucket.bucket.id
  index_document {
    suffix = "index.html"
  }
}

#3. Bucket Policy

resource "aws_s3_bucket_policy" "NewPolicy" {
  
  bucket = aws_s3_bucket.bucket.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "${aws_s3_bucket.bucket.arn}/*"
        }
    ]
})
}


#4. #####Objects for Bucket##########

resource "aws_s3_object" "upload_html" {
  for_each     = fileset("${path.module}/", "*.html")
  bucket       = aws_s3_bucket.bucket.id
  key          = each.value
  source       = "${path.module}/${each.value}"
  etag         = filemd5("${path.module}/${each.value}")
  content_type = "text/html"
}

resource "aws_s3_object" "upload_images" {
  for_each     = fileset("${path.module}/", "*.png")
  bucket       = aws_s3_bucket.bucket.id
  key          = each.value
  source       = "${path.module}/${each.value}"
  etag         = filemd5("${path.module}/${each.value}")
  content_type = "image/png"
}

resource "aws_s3_object" "upload_java" {
  for_each     = fileset("${path.module}/", "*.js")
  bucket       = aws_s3_bucket.bucket.id
  key          = each.value
  source       = "${path.module}/${each.value}"
  etag         = filemd5("${path.module}/${each.value}")
  content_type = "text/js"
}

resource "aws_s3_object" "upload_css" {
  for_each     = fileset("${path.module}/", "*.css")
  bucket       = aws_s3_bucket.bucket.id
  key          = each.value
  source       = "${path.module}/${each.value}"
  etag         = filemd5("${path.module}/${each.value}")
  content_type = "text/css"
}






#### Previous Image Setup #######

# resource "aws_s3_bucket_object" "object" {
#   bucket = aws_s3_bucket.bucket.id
#   key    = "Iza.jpeg"
#   source = "C:/Users/jjgui/Documents/s3/s3projectforclass/Iza.jpeg"
#   acl = "public-read"
# }

# resource "aws_s3_bucket_object" "file" {
#   bucket = aws_s3_bucket.bucket.id
#   key    = "index.html"
#   source = "C:/Users/jjgui/Documents/s3/s3projectforclass/index.html"
#   acl = "public-read"
  
# }


#5. ###Public Access Un-Block##########

resource "aws_s3_bucket_public_access_block" "my_protected_bucket_access" {
  bucket = aws_s3_bucket.bucket.id

  # Block public access
  block_public_acls   = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}



# output "bucket_name" {
#   value = aws_s3_bucket.bucket.bucket
# }

# output "bucket_arn" {
#   value = aws_s3_bucket.bucket.arn
# }

output "website_url" {
  value = "http://${aws_s3_bucket_website_configuration.site.website_endpoint}"
}
