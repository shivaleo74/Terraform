resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "timing"
    Terraform = true
    Environment = "DEV"
  }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"

    tags = {
    Name = "timing_public_subnet"
    Terraform = true
    Environment = "DEV"
  }
}

resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.main.id

    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

    tags = {
        Name = "timing_public_rt"
        Terraform = true
        Environment = "DEV"
    }
}

resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_route_table.id
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/24"

    tags = {
    Name = "timing_private_subnet"
    Terraform = true
    Environment = "DEV"
  }
}

resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "timing_private_rt"
        Terraform = true
        Environment = "DEV"
    }
}

resource "aws_route_table_association" "private" {
    subnet_id = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private_route_table.id
}

resource "aws_subnet" "database_subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.3.0/24"

    tags = {
    Name = "timing_database_subnet"
    Terraform = true
    Environment = "DEV"
  }
}

resource "aws_route_table" "database_route_table" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "timing_database_rt"
        Terraform = true
        Environment = "DEV"
    }
}

resource "aws_route_table_association" "database" {
    subnet_id = aws_subnet.database_subnet.id
    route_table_id = aws_route_table.database_route_table.id
}

#Elastic IP
resource "aws_eip" "nat" {
  domain   = "vpc"

  tags = {
        Name = "timing_eip"
        Terraform = true
        Environment = "DEV"
    }
}

#Nat gateway
resource "aws_nat_gateway" "gw" {
    allocation_id = aws_eip.nat.id
    subnet_id = aws_subnet.public_subnet.id

    tags = {
        Name = "${var.project_name}timing_nat_gw"
        Terraform = true
        Environment = "DEV"
    }
}

resource "aws_route" "private_route" {
    route_table_id = aws_route_table.private_route_table.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw.id
    #depends_on = [aws_route_table.private]
}

resource "aws_route" "database_route" {
    route_table_id            = aws_route_table.database_route_table.id
    destination_cidr_block    = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw.id
    #depends_on = [aws_route_table.private]
}