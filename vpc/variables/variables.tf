variable "cidr_block" {
    type = string
    default = "10.0.0.0/16"
}

variable "instance_tenancy" {
    type = string
    default = "default"
}

variable "enable_dns_support" {
    type = bool
    default = true
}

variable "enable_dns_hostnames" {
    type = bool
    default = true  
}

variable "tags" {
    type = map(string)
    default = {
      Name = "timing"
      Terraform = "true"
      Environment = "DEV"
    }
}

variable "public_subnets" {
    default = {
    public-subnet-1 = {
        Name = "public-subnet-1"
        cider_block = "10.0.1.0/24"
        az = "ap-south-2a"
    }
    public-subnet-2 ={
        Name = "public-subnet-3"
        cider_block = "10.0.2.0/24"
        az = "ap-south-2b"
    }
    public-subnet-3 = {
        Name = "public-subnet-3"
        cider_block = "10.0.3.0/24"
        az = "ap-south-2c"
    }
  }
}

variable "postgres_port" {
    type = number
    default = 5432
}

variable "cidr_list" {
    type = list
    default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "instance_names" {
    type = list
    default = ["Web-Server", "API-Server", "DB-Server"]
}

variable "isProd" {
    type = bool
    default = false
}

variable "env" {
    type = string
    default = "PROD"
}