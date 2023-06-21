# 보안그룹 안만들어졌으니까 반드시 확인할 것

# 디폴트 보안그룹

# 디렉토리가 달라 상태코드 공유가 안된다
# vpc의 상태코드가 s3에 있다고 알려줘야 한다
# vpc 상태코드 가져오자


# data "terraform_remote_state" 여기 까지는 무조건 적어줘야 하는 상수 
#"vpc" 는 바꿀수 있는 것 terraform.tfstate 임

/* resource "aws_default_security_group" "aws15_default_sg" {
  vpc_id = data.terraform_remote_state.aws15_vpc.outputs.vpc_id 

  ingress = {
    protocol = "tcp"
    from_port = 0
    to_port = 65535
    cidr_blocks = [data.terraform_remote_state.aws15_vpc.outputs.vpc_cidr]
  }

  egress = {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "aws15_default_sg"
  Description = "default security group" */
# default로 여러개 보안그룹을 만들면 다같이 겹쳐서 안만들어지고 그냥 새로고침만 된다

# alt shift a  선택영역 전체 주석 처리 단축키

# SSH Security Group

resource "aws_security_group" "aws15_ssh_sg" {
   
     name = "aws15_ssh_sg"
     description = "security group for ssh server"
     vpc_id = data.terraform_remote_state.aws00_vpc.outputs.vpc_id 

     ingress {
     description = "For ssh port"
     from_port = 22
     to_port = 22
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
     }

     egress {
     protocol   = "-1"
     from_port  = 0
     to_port    = 0
     cidr_blocks = ["0.0.0.0/0"]
     }

     tags = {
     Name = "aws15_ssh_sg"
     }
}

# WEB Security Group

resource "aws_security_group" "aws15_web_sg" {
   
     name = "aws15_web_sg"
     description = "security group for web server"
     vpc_id = data.terraform_remote_state.aws00_vpc.outputs.vpc_id 

     ingress {
        description = "For web port"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
     }

     egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
     }

     tags = {
       Name = "aws15_web_sg"
     }
}