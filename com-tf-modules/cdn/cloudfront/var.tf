variable "s3_domain_name"{}
variable "project" {}
variable "aliases" {
    type = list(string)
    default = []
}
variable "custom_error_response" {
  type = list(object({
    error_caching_min_ttl = string
    error_code            = string
    response_code         = string
    response_page_path    = string
  }))

  description = "List of one or more custom error response element maps"
  default     = [
      {
         error_caching_min_ttl = 5
         error_code            = 403
         response_code         = 403
         response_page_path    = "/index.html"
        },
      {
         error_caching_min_ttl = 5
         error_code            = 404
         response_code         = 404
         response_page_path    = "/index.html"
      }
  ]
}

variable "s3_bucket" {}
variable "acm_certificate_arn" {}
variable "create" {
  type        = bool
  default     = false
}

variable "common_tags" {
    type = map(any)
}