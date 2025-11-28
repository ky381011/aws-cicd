# Common Variables
variable "tags" {
  default = {
    Name = "tf_test"
    deploy = "github_actions"
  }
}

# Network Variables
variable "vpc_cidr" {
  default = "172.16.0.0/20"
}

variable "subnet_cidrs" {
  default = {
    subnet0  = "172.16.0.0/24"
  }
}