resource "aws_vpc" "main" {
    cidr_block       = var.cidr_block
    instance_tenancy = var.instance_tenancy
    enable_dns_support = var.enable_dns_support
    enable_dns_hostnames = var.enable_dns_hostnames

    tags = var.tags
  }

  resource "aws_subnet" "public" {
    for_each = var.public_subnets
    vpc_id = aws_vpc.main.id
    cidr_block = each.value.cider_block
    availability_zone = each.value.az

    tags = {
      Name = each.value.Name
    }
  }

#Security Group for Postgres RDS: Port:5432
  resource "aws_security_group" "allow_postgres" {
  name        = "allow_postgres"
  description = "Allow postgres inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "TLS from VPC"
    from_port        = var.postgres_port
    to_port          = var.postgres_port
    protocol         = "tcp"
    cidr_blocks      = var.cidr_list
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  # tags = var.tags
  tags = merge(
    var.tags, 
    {
      Name="timing-RDS7-sg"
      }
    )
}

#EC2 instances will be created inside default VPC
#AMI ID are different for different Regions
# This code uses loop to 
resource "aws_instance" "DB-Server" {
    count = 3
    ami = "ami-0d93ee5ed22b0106a"
    instance_type = "t3.micro"
    tags = {
      Name = var.instance_names[count.index]
    }
}

resource "aws_instance" "condition" {
    ami = "ami-0d93ee5ed22b0106a"
    instance_type = var.env == "PROD" ? "t3.large" : "t2.micro"
    # instance_type = var.isProd ? "t3.large" : "t2.micro"
}

resource "aws_key_pair" "Terraform" {
  key_name   = "terraform"
  public_key = file("C:\\Terraform\\vpc\\variables\\terraform.pub")
}
resource "aws_instance" "cond" {
    key_name = aws_key_pair.Terraform.key_name
    ami = "ami-0d93ee5ed22b0106a"
    instance_type = var.env == "PROD" ? "t3.large" : "t2.micro"
}