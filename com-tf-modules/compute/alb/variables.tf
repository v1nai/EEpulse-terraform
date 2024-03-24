variable "project" {}
variable "env" {}
variable "common_tags" {}
variable "sg_id" {
    type = list(string)
}
variable "vpc_id" {}
# variable "ssl_policy" {}
# variable "certificate_arn" {}