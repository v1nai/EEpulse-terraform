resource "aws_s3_bucket" "state" {
   bucket = "${var.env}-${var.project}-${var.acc_id}-tf-state"
   lifecycle {
    prevent_destroy = true
   } 
    tags = {
        Project = "${var.project}",
        Env = "${var.env}"
    }
}

resource "aws_dynamodb_table" "state_lock" {
   hash_key = "LockID"
   name = "${var.env}-${var.project}-${var.acc_id}-tf-lock"
   billing_mode = "PAY_PER_REQUEST"
   attribute {
    name = "LockID"
    type = "S"
   }
   tags = {
        Project = "${var.project}",
        Env = "${var.env}"
}
}