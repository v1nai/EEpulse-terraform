variable "path" {
    type = list(string)
    default = ["/"]
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
variable "env" {}
variable "project" {}
variable "common_tags" {
    type = map(any)
}
variable "sg_id" {}
#variable "elb_listener_arn" {}
variable "ecs_cluster" {}
variable "iam_roles" {}
variable "vpc_id" {}
variable "efs_id" {}
variable "account_id" {}
variable "region" {}
variable "alb_arn" {}
variable "certificate_arn" {}
#test trigger
variable "ecs_service_desired_count" {}

#  need to modify this also
variable "ecr_repo" {
  default = "eepulse-nodejs"
}
