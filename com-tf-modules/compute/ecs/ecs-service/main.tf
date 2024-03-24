data "aws_caller_identity" "current" {}
# Get ecs task definition role
data "aws_iam_role" "ecs_task_execution_role" {
  depends_on = [var.iam_roles]
  name = "${var.project}-ECSTaskExecutionRole"
}

data "aws_subnet_ids" "test_subnet_ids" {
  vpc_id = var.vpc_id
  tags = {
    Tier = "Private"
  }
}

data "aws_subnet" "test_subnet" {
  count = "${length(data.aws_subnet_ids.test_subnet_ids.ids)}"
  id    = "${tolist(data.aws_subnet_ids.test_subnet_ids.ids)[count.index]}"
}

resource "aws_cloudwatch_log_group" "loggroup" {
  name = "/ecs/${var.project}"
}

# Fargate Task Definition
resource "aws_ecs_task_definition" "task0" {
  family                   = "${var.project}"
  task_role_arn            = data.aws_iam_role.ecs_task_execution_role.arn
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  container_definitions =<<DEFINITION
  [
    {
      "cpu":${var.task_cpu},
      "image": "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/${var.ecr_repo}:${var.image_version}",
      "memory": ${var.task_memory},
      "name": "${var.project}",
      "networkMode": "awsvpc",
      "environment": ${jsonencode(var.task_environment)},
      "secrets": ${jsonencode(var.secrets)},
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group" : "/ecs/${var.project}",
          "awslogs-region":  "${var.aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "portMappings": ${jsonencode(var.portMappings)},
      "mountPoints": ${jsonencode(var.mountPoints)}
    }
  ]
  DEFINITION

  dynamic "volume" {
    for_each = var.volumes
    content {
      name = volume.value.name

      #host_path = lookup(volume.value, "host_path", null)

      # dynamic "docker_volume_configuration" {
      #   for_each = lookup(volume.value, "docker_volume_configuration", [])
      #   content {
      #     autoprovision = lookup(docker_volume_configuration.value, "autoprovision", null)
      #     driver        = lookup(docker_volume_configuration.value, "driver", null)
      #     driver_opts   = lookup(docker_volume_configuration.value, "driver_opts", null)
      #     labels        = lookup(docker_volume_configuration.value, "labels", null)
      #     scope         = lookup(docker_volume_configuration.value, "scope", null)
      #   }
      # }

      dynamic "efs_volume_configuration" {
        for_each = lookup(volume.value, "efs_volume_configuration", [])
        content {
          file_system_id          = lookup(efs_volume_configuration.value, "file_system_id", null)
          root_directory          = lookup(efs_volume_configuration.value, "root_directory", null)
          # transit_encryption      = lookup(efs_volume_configuration.value, "transit_encryption", null)
          # transit_encryption_port = lookup(efs_volume_configuration.value, "transit_encryption_port", null)
          # dynamic "authorization_config" {
          #   for_each = lookup(efs_volume_configuration.value, "authorization_config", [])
          #   content {
          #     access_point_id = lookup(authorization_config.value, "access_point_id", null)
          #     iam             = lookup(authorization_config.value, "iam", null)
          #   }
          # }
        }
      }
    }
  }

  tags = var.common_tags
}



# Fargate Task Definition
resource "aws_ecs_task_definition" "task1" {
  family                   = "${var.project}"
  task_role_arn            = data.aws_iam_role.ecs_task_execution_role.arn
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  container_definitions =<<DEFINITION
  [
    {
      "cpu":${var.task_cpu},
      "image": "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/${var.ecr_repo}:${var.image_version}",
      "memory": ${var.task_memory},
      "name": "${var.project}",
      "networkMode": "awsvpc",
      "environment": ${jsonencode(var.task_environment)},
      "secrets": ${jsonencode(var.secrets)},
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group" : "/ecs/${var.project}",
          "awslogs-region":  "${var.aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "portMappings": ${jsonencode(var.portMappings)},
      "mountPoints": ${jsonencode(var.mountPoints)}
    }
  ]
  DEFINITION

  dynamic "volume" {
    for_each = var.volumes
    content {
      name = volume.value.name

      #host_path = lookup(volume.value, "host_path", null)

      # dynamic "docker_volume_configuration" {
      #   for_each = lookup(volume.value, "docker_volume_configuration", [])
      #   content {
      #     autoprovision = lookup(docker_volume_configuration.value, "autoprovision", null)
      #     driver        = lookup(docker_volume_configuration.value, "driver", null)
      #     driver_opts   = lookup(docker_volume_configuration.value, "driver_opts", null)
      #     labels        = lookup(docker_volume_configuration.value, "labels", null)
      #     scope         = lookup(docker_volume_configuration.value, "scope", null)
      #   }
      # }

      dynamic "efs_volume_configuration" {
        for_each = lookup(volume.value, "efs_volume_configuration", [])
        content {
          file_system_id          = lookup(efs_volume_configuration.value, "file_system_id", null)
          root_directory          = lookup(efs_volume_configuration.value, "root_directory", null)
          # transit_encryption      = lookup(efs_volume_configuration.value, "transit_encryption", null)
          # transit_encryption_port = lookup(efs_volume_configuration.value, "transit_encryption_port", null)
          # dynamic "authorization_config" {
          #   for_each = lookup(efs_volume_configuration.value, "authorization_config", [])
          #   content {
          #     access_point_id = lookup(authorization_config.value, "access_point_id", null)
          #     iam             = lookup(authorization_config.value, "iam", null)
          #   }
          # }
        }
      }
    }
  }

  tags = var.common_tags
}



# Fargate Service Definition
resource "aws_ecs_service" "service" {
  depends_on      = [aws_lb_listener.elb_listener] // Needed so target group is attached to a lb before this runs
  name            = "${var.project}-service${count.index + 1}"  // Service names will be project-service1 and project-service2
  cluster         = var.ecs_cluster
  count           = var.ecs_service_count
  enable_execute_command             = var.enable_execute_command
  task_definition = count.index == 0 ? aws_ecs_task_definition.task0.arn : aws_ecs_task_definition.task1.arn
  desired_count   = var.ecs_service_desired_count
  launch_type     = "FARGATE"
  health_check_grace_period_seconds = var.health_check_grace_period_seconds
  load_balancer {
    target_group_arn = aws_lb_target_group.elb_target_group.arn
    container_name   = "${var.project}-service${count.index + 1}"  // Container names will be project-service1 and project-service2
    container_port   = "${var.container_port}"
  }

  network_configuration {
    subnets         = "${data.aws_subnet.test_subnet.*.id}"
    security_groups = [var.sg_id]
    assign_public_ip = var.assign_public_ip
  }
}

// Assuming you have defined aws_lb_listener.elb_listener and aws_lb_target_group.elb_target_group elsewhere in your configuration


# ELB Target Group
resource "aws_lb_target_group" "elb_target_group" {
  name        = "${var.project}"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
     interval    = "60"
     timeout     = "30"
     healthy_threshold = "2"
     unhealthy_threshold = "5"
     path        = var.health_check
     matcher     = "200" 
 }

  tags = merge(
    var.common_tags
  )
}

resource "aws_lb_listener" "elb_listener" {
  load_balancer_arn = var.alb_arn
  port              = "80"
  protocol          = "HTTP"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = data.aws_acm_certificate.elb_cert.arn

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  #  default_action {
  #    type             = "forward"
  #    target_group_arn = aws_lb_target_group.elb_target_group.arn
  #  }
}

# resource "aws_lb_listener_rule" "rule" {
#   for_each = var.lb_listener_path
#   listener_arn = aws_lb_listener.elb_listener.arn
#   priority     = each.key

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.elb_target_group.arn
#   }
  
#   dynamic "condition" {
#     for_each = length(each.value) > 0 ? [true] : []
#     content {
#       path_pattern {
#         values = each.value
#       }
#     }
#   }
#   # condition {
#   #   field  = "path-pattern"
#   #   values = [each.value]
#   # }
# }


resource "aws_lb_listener" "https_elb_listener" {
  load_balancer_arn = var.alb_arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn
 

   default_action {
     type             = "forward"
     target_group_arn = aws_lb_target_group.elb_target_group.arn
   }
}


resource "aws_lb_listener_rule" "https_rule" {
  for_each = var.lb_listener_path
  listener_arn = aws_lb_listener.https_elb_listener.arn
  priority     = each.key

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.elb_target_group.arn
  }
  
  dynamic "condition" {
    for_each = length(each.value) > 0 ? [true] : []
    content {
      path_pattern {
        values = each.value
      }
    }
  }
}
# module "secure_params" {
#   source   = "../ssm"
#   params   = var.ssm_secure_string_parameters
#   type     = "SecureString"
#   ssm_dependson = var.ssm_dependson
# }