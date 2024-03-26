module "vpc" {
  #source = "git::https://git-codecommit.us-east-1.amazonaws.com/v1/repos/com-tf-modules/network/vpc?ref=v0.1"
  source = "../../../../com-tf-modules/network/vpc"
  env     = "${local.env}"
  project = "${local.project}"
  vpc_name = "${local.env}-vpc"
  vpc_cidr = "${local.vpc_cidr}"
  az_list = ["us-east-2a","us-east-2b"]
  single_nat_gw = true
  customer = "${local.Customer}"
  common_tags = local.common_tags
}

module "comm_sg" {
  source = "../../../../com-tf-modules/network/sg/com-sg"
  env     = "${local.env}"
  project = "${local.project}"
  common_tags = local.common_tags
  vpc_id = module.vpc.vpc_id
}

module "alb_sg" {
  depends_on = [module.vpc]
  source = "../../../../com-tf-modules/network/sg/alb-sg"
  env     = "${local.env}"
  project = "${local.project}"
  common_tags = local.common_tags
  vpc_id = module.vpc.vpc_id
}

module "iam" {
  source = "../../../../com-tf-modules/iam/iam_role_policy_ecs"
  project = "${local.env}-${local.project}"
  common_tags = local.common_tags
}

module "alb" {
  depends_on = [module.vpc]
  source = "../../../../com-tf-modules/compute/alb"
  env     = "${local.env}"
  project = "${local.project}"
  common_tags = local.common_tags
  vpc_id = module.vpc.vpc_id
  sg_id = [module.alb_sg.albsg_id]
}

module "ecs-repo" {
  for_each = toset(["ps-api" , "psb-api"])
  source = "../../../../com-tf-modules/compute/ecr"
  common_tags = local.common_tags
  repository_name = "${local.project}-${each.key}"
  repository_image_tag_mutability = "MUTABLE"
}


module "ecs-cluster" {
  source = "../../../../com-tf-modules/compute/ecs/ecs-cluster"
  project = "${local.env}-${local.project}"
  common_tags = local.common_tags
}

# module "efs" {
#   depends_on = [module.vpc]
#   source = "../../../../com-tf-modules/storage/efs"
#   project = "${local.env}-${local.project}"
#   common_tags = local.common_tags
#   mount_targets = "${data.aws_subnet.test_subnet.*.id}"
#   security_groups = [module.alb_sg.albsg_id,module.comm_sg.sg_id]
# }

module "ecs-service" {
  depends_on = [module.vpc]
  source = "../../../tf-main/svc1/"
  env     = "${local.env}"
  project = "${local.project}"
  common_tags = local.common_tags
  sg_id = module.comm_sg.sg_id
  alb_arn = module.alb.alb_arn
  # elb_listener_arn = module.alb.lb_listener_arn
  ecs_cluster = module.ecs-cluster.ecs_cluster_arn
  iam_roles = [module.iam]
  vpc_id = module.vpc.vpc_id
  # efs_id = module.efs.efs_id
  account_id = local.account_id
  region = local.region
  # certificate_arn = var.acm_certificate_arn
  ecs_service_desired_count = var.ecs_service_desired_count
  alarm_actions = var.alarm_actions
  task_cpu = var.task_cpu
  task_memory = var.task_memory
  
}
module "ecs-service2" {
  depends_on = [module.vpc]
  source = "../../../tf-main/svc2/"
  env     = "${local.env}"
  project = "${local.project}"
  common_tags = local.common_tags
  sg_id = module.comm_sg.sg_id
  alb_arn = module.alb.alb_arn
  #elb_listener_arn = module.alb.lb_listener_arn
  ecs_cluster = module.ecs-cluster.ecs_cluster_arn
  iam_roles = [module.iam]
  vpc_id = module.vpc.vpc_id
  # efs_id = module.efs.efs_id
  account_id = local.account_id
  region = local.region
  # certificate_arn = var.acm_certificate_arn
  ecs_service_desired_count = var.ecs_service_desired_count
  alarm_actions = var.alarm_actions
  task_cpu = var.task_cpu
  task_memory = var.task_memory
  
}

# module "psb_web_s3_bucket" {
#   source = "../../../../com-tf-modules/storage/s3"
#   s3_bucket = "${local.env}-${local.project}-surveybuilderweb"
#   acl = var.acl
#   common_tags = local.common_tags
# }
# module "ps_web_s3_bucket" {
#   source = "../../../../com-tf-modules/storage/s3"
#   s3_bucket = "${local.env}-${local.project}-surveyweb"
#   acl = var.acl
#   common_tags = local.common_tags
# }

module "db" {
  depends_on = [module.vpc]
  source = "../../../../com-tf-modules/storage/rds"
  project = local.project
  env  = local.env
  vpc_security_group_ids = [module.comm_sg.sg_id]
  instance_count = var.instance_count
  instance_type = var.instance_type
  vpc_id = module.vpc.vpc_id
  common_tags = local.common_tags
  alarm_actions = var.alarm_actions
}

/*
module "ec2" {
  depends_on = [module.vpc,module.ec2_sg]
  source        = "../../../../com-tf-modules/compute/ec2"
  project       = local.project
  env           = local.env
  instance_type = "t2.micro"
  disk_size     = "30"
  vpc_id        = module.vpc.vpc_id
  subnet_id =  module.vpc.pulic_subnet_ids[0]
  #subnet_id = ${data.aws_subnet.subnet.*.id}
  common_tags     = local.common_tags
  security_groups = [module.ec2_sg.sg_id, module.comm_sg.sg_id]
  ec2_ami         = var.ec2_ami
  key_name        = var.key_name

}

module "ec2_sg" {
  source      = "../../../../com-tf-modules/network/sg/ec2-sg"
  project     = local.project
  env         = local.env
  common_tags = local.common_tags
  vpc_id      = module.vpc.vpc_id
}
*/

