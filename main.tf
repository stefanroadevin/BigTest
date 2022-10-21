provider "aws"{
    region = var.region
    profile = var.profile
}

#create vpc

resource "aws_vpc" "my_vpc" {
    cidr_block = var.vpcCIDRblock
    instance_tenancy = var.instanceTenancy
    enable_dns_support = var.dnsSupport
    enable_dns_hostnames = var.dnsHostNames
    tags = {
        Name = "my vpc"
    }
}   

#create public subnet

resource "aws_subnet" "my_vpc_public_subnet" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = var.publicsubnetCIDRblock
    map_public_ip_on_launch = var.mapPublicIP
    availability_zone = var.availabilityZonePub
    tags = {
        Name = " my vpc public subnet"
    }
  
}

locals {
    ingress_variables = [
      {
        port = 22
      },
      {
        port = 80
      }
    ]

    
}

resource "aws_security_group" "My_VPC_Security_Group_Public" {
  vpc_id      = aws_vpc.my_vpc.id
  name        = "My VPC Security Group Public"
  description = "My VPC Security Group Public"

dynamic "ingress"  {
  for_each = local.ingress_variables

  content {
    from_port=ingress.value.port
    to_port=ingress.value.port
    protocol="tcp"
    cidr_blocks=["0.0.0.0/0"]
  }
}
egress {
    cidr_blocks = [var.ingressCIDRblockPub]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
  tags = {
    Name = "My VPC Security Group Public"
  }
}

resource "aws_internet_gateway" "My_VPC_GW" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "My VPC Internet Gateway"
  }
}

#create public route table 

resource "aws_route_table" "My_VPC_PUBLIC_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "My PUBLIC VPC Route Table"
  }
}

resource "aws_route" "My_VPC_internet_access" {
  route_table_id         = aws_route_table.My_VPC_PUBLIC_route_table.id
  destination_cidr_block = var.destinationCIDRblock
  gateway_id             = aws_internet_gateway.My_VPC_GW.id
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}


resource "aws_db_instance" "itinfrasoldb" {
  allocated_storage = 20
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t2.micro"
  name = "bestdbever224"
  username = var.db_name
  password = var.db_password
  parameter_group_name = "default.mysql5.7"
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.id
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  port = "3306"
  publicly_accessible  = true

}

resource "aws_subnet" "my_vpc_private_subnet1" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = var.private_subnet_cidrblock1
    map_public_ip_on_launch = false
    availability_zone = var.availabilityZonePriv1
    tags = {
        Name = " my vpc private subnet"
    }
  
}
resource "aws_subnet" "my_vpc_private_subnet2" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = var.private_subnet_cidrblock2
    map_public_ip_on_launch = false
    availability_zone = var.availabilityZonePriv2
    tags = {
        Name = " my vpc private subnet"
    }
  
}

resource "aws_security_group" "rds_sg" {
  name = "rds_sg"
  vpc_id = aws_vpc.my_vpc.id
  
  ingress {
    from_port = "3306"
    to_port = "3306"
    protocol = "tcp"
    security_groups = [aws_security_group.My_VPC_Security_Group_Public.id]
}
}
resource "aws_db_subnet_group" "db_subnet_group" {
  name = "sgpriv"
  subnet_ids = [aws_subnet.my_vpc_private_subnet1.id,aws_subnet.my_vpc_private_subnet2.id]
}

resource "aws_route_table" "My_VPC_PRIVATE_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "My VPC PRIVATE Route Table"
  }
}

resource "aws_route_table_association" "private" {
  route_table_id =  aws_route_table.My_VPC_PRIVATE_route_table.id
  subnet_id = aws_subnet.my_vpc_private_subnet1.id 
}
resource "aws_route_table_association" "private2" {
  route_table_id =  aws_route_table.My_VPC_PRIVATE_route_table.id
  subnet_id = aws_subnet.my_vpc_private_subnet2.id 
}

resource "aws_route_table_association" "my_vpc_public_association" {
    subnet_id = aws_subnet.my_vpc_public_subnet.id
    route_table_id = aws_route_table.My_VPC_PUBLIC_route_table.id
  
}

resource "aws_s3_bucket" "bucket" {
  bucket = "s3besttestwbeb"
  acl    = "public-read"
  

  website {
    index_document = "index.html"
    error_document = "error.html"

    routing_rules = <<EOF
[{
    "Condition": {
        "KeyPrefixEquals": "docs/"
    },
    "Redirect": {
        "ReplaceKeyPrefixWith": "documents/"
    }
}]
EOF
  }
}