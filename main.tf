terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      #version = "~> 4.22"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  #shared_credentials_files = ["~/.aws/credentials"]
  shared_credentials_files = ["/Users/wadoodalam/.aws/credentials"]
}

variable "mojang_server_url" {
  type    = string
  default = "https://launcher.mojang.com/v1/objects/e00c4052dac1d59a1188b2aa9d5a87113aaf1122/server.jar"
}

resource "aws_security_group" "minecraft" {
  ingress {
    description = "Minecraft port"
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "default port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Send Anywhere"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Minecraft Security Group"
  }
}

resource "tls_private_key" "deployer" {
  algorithm = "RSA"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = tls_private_key.deployer.public_key_openssh
}

resource "aws_instance" "minecraft" {
  ami                         = "ami-04a0ae173da5807d3"
  instance_type               = "t2.medium"
  vpc_security_group_ids      = [aws_security_group.minecraft.id]
  associate_public_ip_address = true

  key_name = aws_key_pair.deployer.key_name

  root_block_device {
    volume_size = 30
  }

  tags = {
    Name = "Minecraft-Server"
  }
}

output "instance_ip_addr" {
  value = aws_instance.minecraft.public_ip
}

output "instance_public_dns" {
  value = aws_instance.minecraft.public_dns
}

output "instance_private_key" {
  value     = tls_private_key.deployer.private_key_pem
  sensitive = true
}
