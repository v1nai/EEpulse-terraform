output "vpc" {
  value = module.vpc.vpc_id
}
output "alb_sg" {
    value = module.alb_sg.albsg_id
}

output "comm_sg" {
    value = module.comm_sg.sg_id
}

# output "efs" {
#   value = module.efs.efs_id
# }