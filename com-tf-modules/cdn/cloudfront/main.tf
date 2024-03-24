locals {
    s3_domain_name = var.s3_domain_name
    s3_origin_id = "s3-website-${local.s3_domain_name}"
}

resource "aws_s3_bucket_policy" "bucket_once" {
     count = var.create ? 1 : 0
     bucket = var.s3_bucket
     policy = jsonencode(
            {
               Statement = [
                   {
                       Action    = "s3:GetObject",
                       Effect    = "Allow",
                       Principal = "*",
                       Resource  = "arn:aws:s3:::${var.s3_bucket}/*"
                    }
                ]
               Version   = "2012-10-17"
            }
        )
       lifecycle {
    ignore_changes = all
  } 
    }

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = local.s3_domain_name
    origin_id   = var.s3_bucket

    # s3_origin_config {
    #   origin_access_identity = "origin-access-identity/cloudfront/ABCDEFG1234567"
    # }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.project} CF Distribution"
  default_root_object = "index.html"
  http_version        = "http1.1"

  # logging_config {
  #   include_cookies = false
  #   bucket          = "mylogs.s3.amazonaws.com"
  #   prefix          = "myprefix"
  # }

  aliases = var.aliases

  dynamic custom_error_response {
    for_each = var.custom_error_response
    content {
      error_caching_min_ttl = lookup(custom_error_response.value, "error_caching_min_ttl", null)
      error_code            = custom_error_response.value.error_code
      response_code         = lookup(custom_error_response.value, "response_code", null)
      response_page_path    = lookup(custom_error_response.value, "response_page_path", null)
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.s3_bucket
    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 86400
    default_ttl            = 86400
    max_ttl                = 31536000
  }

  # Cache behavior with precedence 0
  # ordered_cache_behavior {
  #   path_pattern     = "/content/immutable/*"
  #   allowed_methods  = ["GET", "HEAD", "OPTIONS"]
  #   cached_methods   = ["GET", "HEAD", "OPTIONS"]
  #   target_origin_id = local.s3_origin_id

  #   forwarded_values {
  #     query_string = false
  #     headers      = ["Origin"]

  #     cookies {
  #       forward = "none"
  #     }
  #   }

  #   min_ttl                = 0
  #   default_ttl            = 86400
  #   max_ttl                = 31536000
  #   compress               = true
  #   viewer_protocol_policy = "redirect-to-https"
  # }

  # Cache behavior with precedence 1
  # ordered_cache_behavior {
  #   path_pattern     = "/content/*"
  #   allowed_methods  = ["GET", "HEAD", "OPTIONS"]
  #   cached_methods   = ["GET", "HEAD"]
  #   target_origin_id = local.s3_origin_id

  #   forwarded_values {
  #     query_string = false

  #     cookies {
  #       forward = "none"
  #     }
  #   }

  #   min_ttl                = 0
  #   default_ttl            = 3600
  #   max_ttl                = 86400
  #   compress               = true
  #   viewer_protocol_policy = "redirect-to-https"
  # }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = merge(
     var.common_tags
   )

  viewer_certificate {
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.1_2016"
    ssl_support_method             = "sni-only"
    acm_certificate_arn            = var.acm_certificate_arn
  }
}

resource "aws_s3_bucket_policy" "bucket" {
     count = var.create ? 1 : 0
     bucket = var.s3_bucket
     policy = jsonencode(
            {
               Statement = [
                   {
                       Action    = "s3:GetObject",
                       Effect    = "Allow",
                       Principal = {
                           Service = "cloudfront.amazonaws.com"
                        },
                       Resource  = "arn:aws:s3:::${var.s3_bucket}/*",
                       "Condition": {
            "StringEquals": {
                "AWS:SourceArn": "${aws_cloudfront_distribution.s3_distribution.arn}"
            }
        }
                    }
                ]
               Version   = "2012-10-17"
            }
        )
    }