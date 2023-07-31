resource "aws_vpc" "aws00_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  instance_tenancy = "default"

  tags = {
	Name = "aws00_vpc"
  }
}

# ----- 서브넷 ---------------------------------
# 퍼블릭 서브넷 2a
resource "aws_subnet" "aws00_public_subnet2a" {
	vpc_id = aws_vpc.aws00_vpc.id
	cidr_block = var.public_subnet[0]
	availability_zone = var.azs[0]

	tags = {
		Name = "aws00-public-subnet2a"
	}
}

# 퍼블릭 서브넷 2c
resource "aws_subnet" "aws00_public_subnet2c" {
	vpc_id = aws_vpc.aws00_vpc.id
	cidr_block = var.public_subnet[1]
	availability_zone = var.azs[1]

	tags = {
		Name = "aws00-public-subnet2c"
	}
}

# 프라이빗 서브넷 2a
resource "aws_subnet" "aws00_private_subnet2a" {
	vpc_id = aws_vpc.aws00_vpc.id
	cidr_block = var.private_subnet[0]
	availability_zone = var.azs[0]

	tags = {
		Name = "aws00-private-subnet2a"
	}
}

# 프라이빗 서브넷 2c
resource "aws_subnet" "aws00_private_subnet2c" {
	vpc_id = aws_vpc.aws00_vpc.id
	cidr_block = var.private_subnet[1]
	availability_zone = var.azs[1]

	tags = {
		Name = "aws00-private-subnet2c"
	}
}

# Internet Gateway
<<<<<<< HEAD
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.aws00_vpc.id
  tags = {
    Name = "internet-gateway"
  }
}

# eip for NAT
resource "aws_eip" "nat_eip" {
  vpc = true
  depends_on = ["aws_internet_gateway.igw"]
  lifecycle {
        create_before_destroy = true
  }
}

# NAT gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.aws00_public_subnet2a.id
  depends_on = ["aws_internet_gateway.igw"]
}


# AWS에서 VPC를 생성하면 자동으로 router table이 하나 생긴다.
# aws_default_route_table은 route table을 만들지 않고 VPC가 만든
# 기본 route table을 가져와서 terraform이 관리할 수 있게 한다.
resource "aws_default_route_table" "public_rt" {
=======
resource "aws_internet_gateway" "aws00_igw" {
	vpc_id = aws_vpc.aws00_vpc.id

	tags = {
		Name = "aws00-Internet-gateway"
	}
}

# EIP for NAT Gateway
resource "aws_eip" "aws00_eip" {
	vpc = true
	depends_on = [ "aws_internet_gateway.aws00_igw" ]
	lifecycle {
		create_before_destroy = true
	}
}

# NAT Gateway
resource "aws_nat_gateway" "aws00_nat" {
    allocation_id = aws_eip.aws00_eip.id
	# NAT를 생성할 서브넷위치
  	subnet_id = aws_subnet.aws00_public_subnet2a.id
  	depends_on = ["aws_internet_gateway.aws00_igw"]
}

# AWS에서 VPC를 생성하면 자동으로 route table이 하나 생긴다.
# aws_default_route_table은 route table을 만들지 않고 VPC가 만든
# 기본 route table을 가져와서 terraform이 관리할 수 있게 한다.
resource "aws_default_route_table" "aws00_public_rt" {
>>>>>>> ba9aea5570970c9888f8c388cd5805be4e641416
  default_route_table_id = aws_vpc.aws00_vpc.default_route_table_id

	route {
		cidr_block = "0.0.0.0/0"
<<<<<<< HEAD
		gateway_id = aws_internet_gateway.igw.id
	}
  tags = {
    Name = "public route table"
  }
=======
		gateway_id = aws_internet_gateway.aws00_igw.id
	}
  tags = {
    Name = "aws00 public route table"
  }
}

# 디폴트 라우터를 퍼블릭 서브넷에 연결
resource "aws_route_table_association" "aws00_public_rta_2a" {
    subnet_id      = aws_subnet.aws00_public_subnet2a.id
    route_table_id = aws_default_route_table.aws00_public_rt.id
}

resource "aws_route_table_association" "aws00_public_rta_2c" {
    subnet_id      = aws_subnet.aws00_public_subnet2c.id
    route_table_id = aws_default_route_table.aws00_public_rt.id
}

# 프라이빗 라우트 생성 및 프라이빗 서브넷에 연결
resource "aws_route_table" "aws00_private_rt" {
  vpc_id = aws_vpc.aws00_vpc.id
  tags = {
    Name = "aws00 private route table"
  }
}

resource "aws_route_table_association" "aws00_private_rta_2a" {
    subnet_id      = aws_subnet.aws00_private_subnet2a.id
    route_table_id = aws_route_table.aws00_private_rt.id
}

resource "aws_route_table_association" "aws00_private_rta_2c" {
    subnet_id      = aws_subnet.aws00_private_subnet2c.id
    route_table_id = aws_route_table.aws00_private_rt.id
}

resource "aws_route" "aws00_private_rt_table" {
  route_table_id = aws_route_table.aws00_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.aws00_nat.id
>>>>>>> ba9aea5570970c9888f8c388cd5805be4e641416
}