variable "project" {
    type = string
    default = "sample"
}

variable "common_tags" {
    type = map(any)
}

variable "mount_targets" {
    type = list(string)
}

variable "security_groups" {
    type = list
}