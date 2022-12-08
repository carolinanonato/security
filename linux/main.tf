# Specify AWS provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = "~> 1.1.5" # 1.1.5 or above and below 1.2.0
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

data "aws_ami" "ami-amzn2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

}

# Get VPC id of default VPC
data "aws_vpc" "default" {
  default = true
}

# local variables
locals {
  default_tags = module.gloabl_vars.default_tags
  name_prefix  = "${module.gloabl_vars.prefix}-${module.gloabl_vars.env}"
}

# Retrieve default tags
module "gloabl_vars" {
  source = "../modules/global_vars"
}
# Provision SSH key pair for Linux VMs
resource "aws_key_pair" "linux_key" {
  key_name   = "linux_key"
  public_key = file(var.path_to_linux_key)
    tags = merge({
    Name = "${local.name_prefix}-keypair"
    },
    local.default_tags
  )
}

# Security Groups that allows SSH and HTTP access
module "linux_sg" {
  source     = "cloudposse/security-group/aws"
  version    = "0.4.3"
  attributes = ["primary"]

  # Allow unlimited egress
  allow_all_egress = true

  rules = [
    {
      key         = "ssh"
      type        = "ingress"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      self        = null
      description = "Allow SSH from anywhere"
    },
    {
      key         = "HTTP"
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      self        = null
      description = "Allow HTTP from anywhere"
    }
  ]

  vpc_id = data.aws_vpc.default.id
    tags = merge({
    Name = "${local.name_prefix}-LinuxServer-sg"
    },
    local.default_tags
  )
}

# Create Amazon Linux EC2 instances in a default VPC
resource "aws_instance" "linux_vm" {
  count                  = var.num_linux_vms
  ami                    = data.aws_ami.ami-amzn2.id
  key_name               = aws_key_pair.linux_key.key_name
  instance_type          = var.linux_instance_type
  vpc_security_group_ids = [module.linux_sg.id]
  tags = merge({
    Name = "${local.name_prefix}-LinuxServer-${count.index}"
    },
    local.default_tags
  )
}





