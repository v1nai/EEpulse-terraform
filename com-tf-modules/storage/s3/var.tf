variable "s3_bucket" {}
variable "website" {
  description = "Map containing static web-site hosting or redirect configuration."
  type        = map(string)
  default     = {}
}

variable "acl" {
  default = "private"
}

variable "common_tags" {
    type = map(any)
}

variable "application_s3_bucket" {
  type    = list(string)
  default = ["epsurveyweb", "epsurveybuilderweb"] // Provide additional bucket names here
}