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
	cidr_block = var.public_subnet[1]                  #for 나 count로 활용해서 한번 해보세요
	availability_zone = var.azs[1]

	tags = {
	  Name = "aws15-public-subnet2c"                   # $ 활용해서 한번 해보세요
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


# 인터넷 게이트웨이 만들기 a.k.a igw

resource "aws_internet_gateway" "aws15_igw" {
  vpc_id = aws_vpc.aws15_vpc.id

  tags = {
	Name = "aws15-Internet-gateway"
  }
}

# NAT 게이트웨이 때문에 엘라스틱 아이피 a.k.a. 탄력적 아이피 만들어본다

resource "aws_eip" "aws15_eip" {
  vpc = true
  depends_on = [ "aws_internet_gateway.aws15_igw" ]
  lifecycle {
	create_before_destroy = true     #eip를 어떤식으로 제거 할 것인가
  }
}


# NAT 게이트웨이 만들기
# NAT 게이트웨이가 붙으면 엘라스틱 아이피를 만들어줘야 함

resource "aws_nat_gateway" "aws15_nat" {
  allocation_id = aws_eip.aws15_eip.id
  # NAT를 생성할 서브넷 위치 ↓
  subnet_id = aws_subnet.aws15_public_subnet2a.id
  depends_on = [ "aws_internet_gateway.aws15_igw" ]
}

# aws에 vpc를 생성하면 자동으로 라우팅 테이블이 하나 생김
# aws_default_route_tableㅇ 은 라우팅 테이블을 만들지 않고 VPC가 만듬
# 기본 라우팅 테이블을 가져와서 테라폼이 관리할 수 있게 한다.


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


#디폴트 라우터를 퍼블릭 서브넷에 연결
resource "aws_route_table_association" "aws15_public_rta_2a" {
  subnet_id = aws_subnet.aws15_public_subnet2a.id
  route_table_id = aws_default_route_table.aws15_public_rt.id
}

resource "aws_route_table_association" "aws15_public_rta_2c" {
  subnet_id = aws_subnet.aws15_public_subnet2c.id
  route_table_id = aws_default_route_table.aws15_public_rt.id
}

# 프라이빗 라우트 생성

resource "aws_route_table" "aws15_private_rt" {
  vpc_id = aws_vpc.aws15_vpc.id
  tags = {
	Name = "aws15 private route table"
  }
}


#프라이빗 라우터를 프라이빗 서브넷에 연결
resource "aws_route_table_association" "aws15_private_rta_2a" {
  subnet_id = aws_subnet.aws15_private_subnet2a.id
  route_table_id = aws_route_table.aws15_private_rt.id
}

resource "aws_route_table_association" "aws15_private_rta_2c" {
  subnet_id = aws_subnet.aws15_private_subnet2c.id
  route_table_id = aws_route_table.aws15_private_rt.id
}


# 프라이빗 라우트를 NAT 게이트웨이에 연결
resource "aws_route" "aws15_private_rt_table" {
  route_table_id = aws_route_table.aws15_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.aws15_nat.id
}

#보안 그룹 만들시 VPC 필요/ 서브넷 필요 x
# 인스턴스 만들시 vpc 서브넷 필요

# 다른 상태 코드는 아웃풋으로 된 것만 가져올 수 있음
# 상태 코드를 땡겨올 때 모든 걸 가져올 수는 없고 아웃풋 한거만 가져올 수 있다 이말임
