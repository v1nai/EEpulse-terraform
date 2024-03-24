# modified the keyname, region,customer,project
env  = "dev"
vpc_cidr = "10.0.0.0/16"
region = "us-east-2"
# modify the account number
acm_certificate_arn = "arn:aws:acm:us-east-1:623587607600:certificate/19a97f39-d2d7-4b04-85d4-f164b5b9498a"
instance_count = "1"
instance_type = "db.t3.medium"
key_name = "dev-eepulse"
ecs_service_desired_count = "2"
# modify the accout number 
alarm_actions = "arn:aws:sns:us-east-1:623587607600:Alarm_DEV"
customer = "dev-eepulse"
project = "eepulse"
