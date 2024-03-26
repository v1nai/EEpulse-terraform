terraform {
  required_version = "> 1.1.2"

  backend "s3" {
      ## bucket = "dev-ballotda-623587607600-tf-state"
      # key    = "dev/us-east-1/stack/terraform.tfstate"
      # region = "us-east-1"
      # dynamodb_table = "dev-ballotda-623587607600-tf-lock"
      # encrypt = true
  }
}

provider "aws" {
     version = "~> 4.0"
     region = "us-east-2"
     #allowed_account_ids = ["374562206220"]
}

data "aws_caller_identity" "current" {}

data "aws_subnet_ids" "private" {
  vpc_id = module.vpc.vpc_id
  tags = {
    Tier = "Private"
  }
}

data "aws_subnet" "test_subnet" {
  count = "${length(data.aws_subnet_ids.private.ids)}"
  id    = "${tolist(data.aws_subnet_ids.private.ids)[count.index]}"
}
# modified the name of cognito pool
resource "aws_cognito_user_pool" "user_pool" {
  name = "eepulse-user-pool"
  
  username_attributes = ["email"]
  auto_verified_attributes = ["email"]
  
  schema {
    attribute_data_type = "String"
    name = "email"
    required = true
  }
  
  schema {
    attribute_data_type = "String"
    name = "name"
    required = true
  }
  
   lifecycle {
    ignore_changes = all
  }
  
}
# modified the project name , project

locals {
  env  = var.env
  project = "eepulse"
  vpc_cidr = var.vpc_cidr
  account_id = data.aws_caller_identity.current.account_id
  region = var.region
  Customer= var.customer
  common_tags = tomap({
    "Env"= var.env,
    "Project"= "eepulse",
    "ManagedBy"="Terraform",
    "Customer"= var.customer
    
  })
}

