env  = "prod"
vpc_cidr = "10.20.0.0/16"
region = "us-east-2"  # modified region
# need to modify with the prod account number
acm_certificate_arn = "arn:aws:acm:us-east-1:522623152873:certificate/dbb4cc64-d1ca-4e8b-a3cf-c1f5278a10a9"
instance_count = "1"
instance_type = "db.t3.medium"
key_name = "qa-bastion"
ecs_service_desired_count = "2"
# need to modify with the prod account number
alarm_actions = "arn:aws:sns:us-east-1:522623152873:QA_BallotDA"
# modified the customer name and project
customer = "prod-eepulse"
project = "eepulse"