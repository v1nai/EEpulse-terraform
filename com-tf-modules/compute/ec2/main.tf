resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "iam_profile"
  role = aws_iam_role.Instance_role.name
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
   
  }
  
}


resource "aws_iam_role" "Instance_role" {
  name               = "iam_role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

}
resource "aws_iam_policy_attachment" "ssm_manager_attachment" {
  name       = "ssm-manager-attachment"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  roles      = [aws_iam_role.Instance_role.name]
}

# data "aws_subnet_ids" "test_subnet_ids" {
#   vpc_id = var.vpc_id
#   tags = {
#     Tier = "Public"
#   }
# }

# data "aws_subnet" "test_subnet" {
#   count = "${length(data.aws_subnet_ids.test_subnet_ids.ids)}"
#   id    = "${tolist(data.aws_subnet_ids.test_subnet_ids.ids)[count.index]}"
# }


resource "aws_instance" "bastion-prod" {
  ami              = var.ec2_ami
  instance_type    = var.instance_type
  key_name   = var.key_name
  vpc_security_group_ids = var.security_groups
  subnet_id = var.subnet_id
  monitoring = true
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  root_block_device {
    volume_size = var.disk_size
    volume_type = "gp2"
    delete_on_termination = true
  }
  tags = merge(
     var.common_tags
   )
}