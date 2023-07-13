resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr  
    instance_tenancy = "default"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "timing"
        Terraform = "true"
        Environment = "DEV"
    }
  }

resource "aws_subnet" "public_subnets" {
count = length((var.public_subnet_cider)) #count = 2
vpc_id = aws_vpc.main.id
cidr_block = var.public_subnet_cider[count.index]
availability_zone = var.azs[count.index]

tags = {
    Name = var.public_subnet_names[count.index]
}
}

resource "aws_subnet" "private_subnets" {
    for_each = var.private_subnets
    vpc_id = aws_vpc.main.id
    cidr_block = each.value.cidr
    availability_zone = each.value.az

    tags = {
      Name = each.value.Name
    }
  }