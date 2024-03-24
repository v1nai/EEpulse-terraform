locals {
  any_port     = 0
  https_port   = "443"
  any_protocol = "-1"
  all_ips      = ["0.0.0.0/0"]
}

resource "aws_security_group" "albsg" {
  name = "${var.env}-${var.project}-alb_sg"
  vpc_id = var.vpc_id
  description = "Terraformed"

 tags = merge(
    var.common_tags
  )
}

resource "aws_security_group_rule" "alb_egress_all" {
  type              = "egress"
  security_group_id = aws_security_group.albsg.id
  from_port         = local.any_port
  to_port           = local.any_port
  protocol          = local.any_protocol
  cidr_blocks       = local.all_ips
  description       = "Allow All Traffic Out"
}

resource "aws_security_group_rule" "ingress_http_all" {
  type              = "ingress"
  security_group_id = aws_security_group.albsg.id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = local.all_ips
  description       = "Allow All Traffic IN"
}