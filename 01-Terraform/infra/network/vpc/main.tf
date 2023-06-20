resource "aws_vpc" "aws15_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  instance_tenancy = "default"

  tags = {
	Name = "aws15_vpc"
  }
}

# 컨트롤 쉬프트 L 누르면 같은 이름 한번에 다 수정됨

# =================  서브넷=================================
# 퍼블릭 서브넷 2a
resource "aws_subnet" "aws15_public_subnet2a" {
    vpc_id = aws_vpc.aws15_vpc.id
	cidr_block = var.public_subnet[0]
	availability_zone = var.azs[0]

	tags = {
	  Name = "aws15-public-subnet2a"
	}
}

# 퍼블릭 서브넷 2c
resource "aws_subnet" "aws15_public_subnet2c" {
    vpc_id = aws_vpc.aws15_vpc.id
	cidr_block = var.public_subnet[1]
	availability_zone = var.azs[1]

	tags = {
	  Name = "aws15-public-subnet2c"
	}
}

# 프라이빗 서브넷 2a
resource "aws_subnet" "aws15_private_subnet2a" {
    vpc_id = aws_vpc.aws15_vpc.id
	cidr_block = var.private_subnet[0]
	availability_zone = var.azs[0]

	tags = {
	  Name = "aws15-private-subnet2a"
	}
}

# 프라이빗 서브넷 2c
resource "aws_subnet" "aws15_private_subnet2c" {
    vpc_id = aws_vpc.aws15_vpc.id
	cidr_block = var.private_subnet[1]
	availability_zone = var.azs[1]

	tags = {
	  Name = "aws15-private-subnet2c"
	}
}