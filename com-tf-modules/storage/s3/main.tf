resource "aws_s3_bucket" "bucket" {
  bucket        = var.s3_bucket
  #force_destroy = "true"
 # bucket_regional_domain_name =
 dynamic "website" {
    for_each = length(keys(var.website)) == 0 ? [] : [var.website]

    content {
      index_document           = lookup(website.value, "index_document", null)
      error_document           = lookup(website.value, "error_document", null)
      redirect_all_requests_to = lookup(website.value, "redirect_all_requests_to", null)
      routing_rules            = lookup(website.value, "routing_rules", null)
    }
  }
  lifecycle {
    prevent_destroy = true
  }
  tags = merge(
     var.common_tags
   )
}

resource "aws_s3_bucket_acl" "acl" { 
    bucket = aws_s3_bucket.bucket.id 
    acl = var.acl 

    depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}
/*resource "aws_s3_bucket_versioning" "versioning" {  
    bucket = aws_s3_bucket.my-bucket.id 
    versioning_configuration { 
        status = 
    }
}*/
resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [aws_s3_bucket_public_access_block.block-public-access]
}
resource "aws_s3_bucket_public_access_block" "block-public-access" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# added for the s3 buckets 
resource "aws_s3_bucket" "application_buckets" {
  count         = 2 // Creating 2 additional buckets
  bucket        = var.application_s3_bucket[count.index]
  acl           = var.acl
  force_destroy = true
  tags = merge(
    var.common_tags
  )
}