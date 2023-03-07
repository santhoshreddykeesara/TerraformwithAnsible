variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "zones" {
  default = ["us-west-2a","us-west-2b","us-west-2c"]
}

variable "public_sub" {
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

}

variable "private_sub" {
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

}


