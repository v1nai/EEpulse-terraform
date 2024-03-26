
module "svc2" {
    source = "../../../com-tf-modules/compute/ecs/ecs-service"
    env = var.env
    project = "${var.project}"
    common_tags = var.common_tags
    sg_id = var.sg_id
    task_cpu = var.task_cpu
    task_memory = var.task_memory
    #elb_listener_arn = var.elb_listener_arn
    ecs_cluster = var.ecs_cluster
    ecs_cluster_name = "${var.env}-${var.project}-ecs-cluster"
    ecs_servicename = "${var.env}-${var.project}-psb-api"
    service_name = "psb-api"
    vpc_id = var.vpc_id
    container_port = "8080"
    ecr_repo = "${var.env}-${var.project}-${var.ecr_repo}"
    image_version = "latest"
    alb_arn = var.alb_arn
    lb_listener_path = {
        "60" = var.path
    }
    alarm_actions = var.alarm_actions
    ecs_service_desired_count = "${var.ecs_service_desired_count}"
    iam_roles = var.iam_roles
    assign_public_ip = false
    ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"
    # certificate_arn = var.certificate_arn
    health_check = "/en/home"
    secrets = [
        {
            "name" = "RDS_DB_URL"
            "valueFrom" = "arn:aws:ssm:${var.region}:${var.account_id}:parameter/${var.env}-${var.project}.db.url"
        },
        {
            "name" = "RDS_DB_USERNAME"
            "valueFrom" = "arn:aws:ssm:${var.region}:${var.account_id}:parameter/${var.env}-${var.project}.db.admin.username"
        },
        {
            "name" = "RDS_DB_PASSWORD"
            "valueFrom" = "arn:aws:ssm:${var.region}:${var.account_id}:parameter/${var.env}-${var.project}.db.admin.password"
        }
    ]
    # mountPoints = [
    #             {
    #                 "sourceVolume": "${var.env}-${var.project}-vol",
    #                 "containerPath": "/var/www/html/uploads",
    #                 "readOnly": false
    #             }
    #         ]
    # volumes = [
    #     {
    #     name = "${var.env}-${var.project}-vol"
    #     efs_volume_configuration = [
    #         {
    #             file_system_id = "${var.efs_id}"
    #             root_directory = null
    #         }
    #     ]
    #     }
    # ]
}