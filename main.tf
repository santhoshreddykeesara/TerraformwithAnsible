terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>4.57.0"
      
    }
     
  }
}
provider "aws" {
  region = "us-west-2"
}

data "aws_ami" "amzn2" {
  most_recent = true
  
  filter {
    name = "name"
    values = ["amzn2-ami-kernel-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "web_ingress" {
  #vpc_id      = module.vpc.vpc_id
  ingress {
    from_port   = 80
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    "name" = "terraform_created"
  }
}

# resource "aws_network_interface" "ec2_network" {
#   subnet_id       = module.vpc.public_subnets[0]
#   #private_ips     = ["10.0.0.50"]
#   security_groups = [aws_security_group.web_ingress.id]

#   attachment {
#     instance     = aws_instance.tf_test.id
#     device_index = 1
#   }
# }

resource "aws_instance" "terraform_ansible" {
  ami = data.aws_ami.amzn2.id
  #vpc_id = module.vpc.id
  #subnet_id = module.vpc.public_subnets[0]
  instance_type = "t3.micro"
  count = "2"
  key_name = "Aws_oregon"
  #associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.web_ingress.id]
  user_data = file("${path.module}/userdata.sh")
  user_data_replace_on_change = true

  tags = {
    "Name" = "Ansible_hosts"
  }
}

resource "null_resource" "patience" {
  depends_on = [
    aws_instance.terraform_ansible
  ]
provisioner "local-exec" {
  #command = "ansible-playbook -i '${aws_instance.terraform_ansible[1].public_dns},' install-webserver.yml"
  #command = "sleep 60 & echo \"sleeping in PID $!\""
  command = "ansible-playbook -i '${aws_instance.terraform_ansible[1].public_dns},' install-webserver.yaml"
}
}
