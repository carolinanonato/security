data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "aws_ami" "ubuntu" {
  owners      = ["099720109477"]
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}


resource "aws_key_pair" "vm_key" {
  key_name   = var.vmprefix
  public_key = file("~/.ssh/${var.vmprefix}.pub")
}

resource "aws_instance" "linux" {
  for_each               = var.cidr_subnet_block
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.aws_subnet_block[each.key].id
  vpc_security_group_ids = [aws_security_group.vm_security_group.id]
  key_name               = aws_key_pair.vm_key.key_name
  availability_zone      = contains(["SN1"], each.key) ? "us-east-1a" : "us-east-1b"
  tags = merge("${var.default_tags_RedHat}",
    {
      "Name" = "${var.prefix}-Linux"
    }
  )
}

resource "aws_instance" "ubuntu" {
  for_each               = var.cidr_subnet_block
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.aws_subnet_block[each.key].id
  vpc_security_group_ids = [aws_security_group.vm_security_group.id]
  key_name               = aws_key_pair.vm_key.key_name
  availability_zone      = contains(["SN1"], each.key) ? "us-east-1a" : "us-east-1b"
  tags = merge("${var.default_tags_Debian}",
    {
      "Name" = "${var.prefix}-ubuntu"
    }
  )
}
