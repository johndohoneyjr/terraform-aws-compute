variable "key_name" {
  default="tf_key"
}

variable "subnet_ips" {
    type = "list"
    default=["10.0.20.0", "10.0.30.0"]
}
variable "instance_count" {
  default=2
}
variable "instance_type" {
  default="t2.medium"
}

variable "security_group" {
  default="default"
}

variable "subnets" {
 type = "list"
 default=["10.0.20.0", "10.0.30.0"]
}

variable "aws_access_key" {
  default="none"
}
variable "aws_secret_key" {
  default="none"
}
