resource "aws_ecs_cluster" "cluster" {
  name = "${var.project}-ecs-cluster"

  tags = merge(
    var.common_tags
  )
}