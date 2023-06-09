provider "aws" {
  region = "ap-northeast-2"
}

# aws 인스턴스 생성
# aws launch configuration 시작 구성 만들기
resource "aws_launch_configuration" "example" {
  image_id        = "ami-0c6e5afdd23291f73"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.instance.id]
  user_data = <<-EOF
      #!/bin/bash
      echo "Hello, World" > index.html
      nohup busybox httpd -f -p ${var.server_port} &
      EOF
  lifecycle {
    create_before_destroy = true
  }
}

# aws 오토스케일링 그룹 생성
resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.name
  vpc_zone_identifier  = data.aws_subnets.default.ids

  min_size = 1
  max_size = 2

  tag {
    key                 = "Name"
    value               = "aws15-terraform-asg-example"
    propagate_at_launch = true
  }
}

# 보안그룹 생성
resource "aws_security_group" "instance" {
  name = "aws15-terrafrom-example-instance"
  vpc_id = data.aws_vpc.default.id
# 인바운드 규칙 설정
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# default vpc 정보 가지고 오기 

variable "server_port" {

  description = "the port will use for HTTP requests"
  type        = number
  default     = 8080
}

data "aws_vpc" "default" {
  filter {
		name = "tag:Name"
		values = ["604-vpc"]
	}
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = ["data.aws_vpc.default.id"]
  }
}


