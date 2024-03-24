variable "env" {
  type = string
}

variable "customer" {
  type = string
}
# variable "app_module" {
#   type = string
# }
variable "vpc_cidr" {
  type = string
}
variable "task_cpu" {
  type = string
  default = "1024"
}

variable "task_memory" {
  type = string
  default = "2048"
}
variable "alarm_actions" {
  type = string
}

variable "region" {
  type = string
}

variable "acm_certificate_arn" {}
variable "key_name" {}
variable "ec2_ami" {
  default = "ami-0fc5d935ebf8bc3bc"
}

variable "instance_count" {
  default = ""
}
variable "instance_type" {
  default = ""
}
variable "ecs_service_desired_count" {
  default = ""
}
variable "acl" {
  default = "private"
}
