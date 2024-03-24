variable "project" {
  type = string
}

variable "env" {}

variable "common_tags" {
    type = map(any)
}


variable "task_cpu" {
  type = string
  default = "1024"
}

variable "task_memory" {
  type = string
  default = "2048"
}

variable "ecr_repo" {
  default = "nginx"
}


variable "image_version" {
  default = "latest"
}

variable "portMappings" {
  default = [
      {
        "containerPort" = 8080 
        "hostPort" = 8080
      }
    ]
}

variable "mountPoints" {
  default = []
}

variable "task_environment" {
  default = []
}

variable "secrets" {
  default = []
}

variable "health_check_grace_period_seconds" {
  type = string
  default = "180"
}
variable "enable_execute_command" {
  description = "Specifies whether to enable Amazon ECS Exec for the tasks within the service"
  type        = bool
  default     = true
}
variable "sg_id" {}

variable "health_check" {
  default = "/health"
}

variable "lb_listener_path" {
  type = map(any)
}

variable "alb_arn" {
  type = string
}

variable "ecs_service_desired_count" {
  type = string
}

variable "ecs_service_count" {
  type    = number
  default = 2  # You can adjust this default value as needed
}

# variable "elb_listener_arn" {
#   type = string
# }

variable "iam_roles" {}
variable "assign_public_ip" {
  default = "true"
}
variable "aws_region" {
  default = "us-east-1"
}

variable "ecs_cluster" {}
variable "container_port" {}
variable "vpc_id" {}

variable "volumes" {
  description = "(Optional) A set of volume blocks that containers in your task may use"
  type = list(object({
    name      = string

    efs_volume_configuration = list(object({
      file_system_id          = string
      root_directory          = string
    }))
  }))
  default = []
}

variable "ssl_policy" {}
variable "certificate_arn" {}

#Monitoring

variable "critical_cpu_consumedthreshold" {
  default = "90"
}

variable "critical_memory_consumedthreshold" {
  default = "90"
}

variable "cpu_evaluation_periods" {
  default = 1
}

variable "cpu_period" {
  default = 300
}

variable "memory_evaluation_periods" {
  default = 1
}

variable "memory_period" {
  default = 300
}

variable "ok_actions" {
  default = []
}

variable "actions_enabled" {
  default = "true"
}

variable "alarm_actions" {
  type = string
}

variable "ecs_servicename" {
  default = ""
}

variable "ecs_cluster_name" {
  default = ""
}
