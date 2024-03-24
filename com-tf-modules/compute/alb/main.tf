# Get Public Subnets

data "aws_subnet_ids" "public" {
  vpc_id = var.vpc_id
  tags = {
    Tier = "Public"
  }
}
data "aws_subnet" "test_subnet" {
  count = "${length(data.aws_subnet_ids.public.ids)}"
  id    = "${tolist(data.aws_subnet_ids.public.ids)[count.index]}"
}

resource "aws_lb" "elb" {
  name               = "${var.env}-${var.project}-elb"
  internal           = false
  load_balancer_type = "application"
  security_groups    =  var.sg_id
  subnets = "${data.aws_subnet.test_subnet.*.id}"

  tags = merge(
    var.common_tags
  )
}

# resource "aws_lb_target_group" "tg" {
#   name        = "${var.env}-${var.project}"
#   port        = 80
#   protocol    = "HTTP"
#   target_type = "ip"
#   vpc_id      = var.vpc_id
# }
/*

resource "aws_lb_listener" "listener-http" {
  load_balancer_arn = aws_lb.elb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
*/

# resource "aws_lb_listener" "elb-listener" {
#   load_balancer_arn = aws_lb.elb.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = var.ssl_policy
#   certificate_arn   = var.certificate_arn

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.tg.arn
#   }
# }

# resource "aws_lb_listener_rule" "listener-rule" {
#   listener_arn = aws_lb_listener.elb-listener.arn
#   priority     = 60

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.tg.arn
#   }

#   condition {
#     path_pattern {
#       values = ["/"]
#     }
#   }

#   condition {
#     host_header {
#       values = ["ballotda.com"]
#     }
#   }
# }

