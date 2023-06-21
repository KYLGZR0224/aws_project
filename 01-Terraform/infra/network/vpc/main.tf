resource "aws_vpc" "aws15_vpc" {
  cidr_block = var.vpc_cidr # variable.tf에서 가용영역이 바뀔수 있어 변수 처리 해놓은 것
  enable_dns_hostnames = true #DNS 호스트 네임을
  enable_dns_support = true   #지원 할 것인가에 대하여 트루 값으로 설정 해놓은 것
  instance_tenancy = "default" # 테넌시는 웬만하면 디폴트 값으로 함 다른걸 쓸일이 없음

  tags = {
	Name = "aws15_vpc"
  }
}

# 컨트롤 쉬프트 L 누르면 같은 이름 한번에 다 수정됨

# =================  서브넷=================================
# 퍼블릭 서브넷 2a
resource "aws_subnet" "aws15_public_subnet2a" {
    vpc_id = aws_vpc.aws15_vpc.id                    # VPC id는 위에서 만든 VPC명을 그대로 땡겨온 것
	cidr_block = var.public_subnet[0]                # cidr block을 변수로 지정하여 나중에 변수 값만 수정하면 됨 [0]은 2a 영역 cidr [1]은 2c 영역 cidr
	availability_zone = var.azs[0]                   # 가용 영역에 대하여 변수로 지정 한 것 [0]은 2a 영역이고 [1]은 2c 영역임

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