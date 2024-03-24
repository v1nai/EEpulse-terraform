variable "env" {
  type = string
}

variable "project" {
  type = string
}

variable "instance_count" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "skip_final_snapshot" {
  type    = string
  default = "true"
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "backup_retention_period" {
  type = string
  default = "7"
}

variable "preferred_backup_window" {
  type        = string
  default     = "05:00-05:30"
}

variable "master_username" {
  type = string
  default = "admin"
}

variable "copy_tags_to_snapshot" {
  type = bool
  default = false
}

variable "deletion_protection" {
  type = string
  default = "false"
}

variable "preferred_maintenance_window" {
  type = string
  default = "sun:07:00-sun:07:30"
}

variable "port" {
  type = string
  default = "3306"
}

variable "storage_encrypted" {
  type = bool
  default = true
}

variable "apply_immediately" {
  type = bool
  default = false
}

variable "engine_version" {
  type = string
  default = "5.7.mysql_aurora.2.11.2"
}

variable "enabled_cw_logs_exports" {
  description = "Supported log types: audit, error, general, slowquery. Individual logs may need to be enabled via Aurora parameter groups"
  type = list(string)
  default = ["error"]
}

variable "cw_logs_retention_period" {
  type = string
  default = "14"
}

variable "auto_minor_version_upgrade" {
  type = bool
  default = true
}

variable "common_tags" {
    type = map(any)
}

variable "vpc_id" {}

#Monitoring

variable "critical_cpu_consumedthreshold" {
  default = "90"
}

variable "critical_memory_consumedthreshold" {
  default = "10"
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

variable "dbconnections_evaluation_periods" {
  default = 1
}

variable "dbconnections_period" {
  default = 300
}

variable "dbconnections_threshold" {
  default = 200
}