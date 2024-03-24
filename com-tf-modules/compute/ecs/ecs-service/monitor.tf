locals {
    thresholds = {
        critical_cpu_consumedthreshold = min(max(var.critical_cpu_consumedthreshold, 0), 100)
        critical_memory_consumedthreshold = min(max(var.critical_memory_consumedthreshold, 0), 100)
    }

    dimensions_map = {
        "service" = {
           "ClusterName" = var.ecs_cluster_name
           "ServiceName" = var.ecs_servicename
        }
        "cluster" = {
            "ClusterName" = var.ecs_cluster_name
        }
    }
}

module "critical_cpu_consumedthreshold" {
  source = "../../../cloudwatch"
  alarm_name          = "${var.project}-ecs-critical-alert-cpu-consumed-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.cpu_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = var.cpu_period
  statistic           = "Average"
  threshold           = local.thresholds["critical_cpu_consumedthreshold"]
  alarm_description   = "${var.project} - CPU Utilization is High"
  ok_actions          = var.ok_actions
  actions_enabled     = var.actions_enabled
  alarm_actions       = [var.alarm_actions]
  dimensions          = local.dimensions_map["${var.project}" == "" ? "cluster" : "service"]
  tags                = var.common_tags
}

module "critical_memory_consumedthreshold" {
  source = "../../../cloudwatch"
  alarm_name          = "${var.project}-ecs-critical-alert-memory-consumed-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.memory_evaluation_periods
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = var.memory_period
  statistic           = "Average"
  threshold           = local.thresholds["critical_memory_consumedthreshold"]
  alarm_description   = "${var.project} - Memory Utilization is High"
  ok_actions          = var.ok_actions
  actions_enabled     = var.actions_enabled
  alarm_actions       = [var.alarm_actions]
  dimensions          = local.dimensions_map["${var.project}" == "" ? "cluster" : "service"]
  tags                = var.common_tags
}