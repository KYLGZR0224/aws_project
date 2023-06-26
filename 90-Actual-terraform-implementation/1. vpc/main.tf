# VPC
resource "aws_vpc" "aws15_vpc" {
  cidr_block = var.vpc_cidr 
  enable_dns_hostnames = true 
  enable_dns_support = true   
  instance_tenancy = "default" 
  tags = {
	Name = "aws15_vpc"
  }
}

# Public Subnet 2a
resource "aws_subnet" "aws15_public_subnet2a" {
    vpc_id = aws_vpc.aws15_vpc.id                    
	cidr_block = var.public_subnet[0]                
	availability_zone = var.azs[0]                   
	tags = {
	  Name = "aws15-public-subnet2a"
	}
}

# Public Subnet 2c
resource "aws_subnet" "aws15_public_subnet2c" {
    vpc_id = aws_vpc.aws15_vpc.id
	cidr_block = var.public_subnet[1]                  
	availability_zone = var.azs[1]

	tags = {
	  Name = "aws15-public-subnet2c"                   
	}
}

# Private Subnet 2a
resource "aws_subnet" "aws15_private_subnet2a" {
    vpc_id = aws_vpc.aws15_vpc.id
	cidr_block = var.private_subnet[0]
	availability_zone = var.azs[0]

	tags = {
	  Name = "aws15-private-subnet2a"
	}
}

# Private Subnet 2c
resource "aws_subnet" "aws15_private_subnet2c" {
    vpc_id = aws_vpc.aws15_vpc.id
	cidr_block = var.private_subnet[1]
	availability_zone = var.azs[1]

	tags = {
	  Name = "aws15-private-subnet2c"
	}
}

# Internet Gateway
resource "aws_internet_gateway" "aws15_igw" {
  vpc_id = aws_vpc.aws15_vpc.id

  tags = {
	Name = "aws15-Internet-gateway"
  }
}

# Elastic IP
resource "aws_eip" "aws15_eip" {
  vpc = true
  depends_on = [ "aws_internet_gateway.aws15_igw" ]
  lifecycle {
	create_before_destroy = true    
  }
}

# NAT Gateway
resource "aws_nat_gateway" "aws15_nat" {
  allocation_id = aws_eip.aws15_eip.id
  # NAT를 생성할 서브넷 위치 ↓
  subnet_id = aws_subnet.aws15_public_subnet2a.id
  depends_on = [ "aws_internet_gateway.aws15_igw" ]
}

# Public Routing Table
resource "aws_default_route_table" "aws15_public_rt" {
   default_route_table_id = aws_vpc.aws15_vpc.default_route_table_id

  route {
	cidr_block = "0.0.0.0/0"
	gateway_id = aws_internet_gateway.aws15_igw.id
  }
  tags = {
	Name = "aws15 public route table"
  }
}

# Public Routing Table Boundary
resource "aws_route_table_association" "aws15_public_rta_2a" {
  subnet_id = aws_subnet.aws15_public_subnet2a.id
  route_table_id = aws_default_route_table.aws15_public_rt.id
}

resource "aws_route_table_association" "aws15_public_rta_2c" {
  subnet_id = aws_subnet.aws15_public_subnet2c.id
  route_table_id = aws_default_route_table.aws15_public_rt.id
}

# Private Routing Table
resource "aws_route_table" "aws15_private_rt" {
  vpc_id = aws_vpc.aws15_vpc.id
  tags = {
	Name = "aws15 private route table"
  }
}

# Private Routing Table Boundary
resource "aws_route_table_association" "aws15_private_rta_2a" {
  subnet_id = aws_subnet.aws15_private_subnet2a.id
  route_table_id = aws_route_table.aws15_private_rt.id
}

resource "aws_route_table_association" "aws15_private_rta_2c" {
  subnet_id = aws_subnet.aws15_private_subnet2c.id
  route_table_id = aws_route_table.aws15_private_rt.id
}

# NAT Gatewat와 Public Routing Table 연결
resource "aws_route" "aws15_private_rt_table" {
  route_table_id = aws_route_table.aws15_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.aws15_nat.id
}