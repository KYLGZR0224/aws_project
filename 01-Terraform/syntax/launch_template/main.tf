provider "aws" {
  region = "ap-northeast-2"
}

# aws 인스턴스 생성
# aws launch template
resource "aws_launch_template" "example" {
  name                    = "aws15-example"
  image_id                = "ami-0c6e5afdd23291f73"
  instance_type           = "t2.micro"
  key_name                = "aws15-key"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = "${base64encode(data.template_file.web_output.rendered)}"

  lifecycle {
    create_before_destroy = true
  }
}

# aws 오토스케일링 그룹 생성
resource "aws_autoscaling_group" "example" {
  availability_zones = ["ap-northeast-2a", "ap-northeast-2c"]

  name             = "aws15-terraform-asg-example"
  desired_capacity = 1
  min_size         = 1
  max_size         = 2

  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "aws15-terraform-asg-example"
    propagate_at_launch = true
  }
}

# 보안그룹 생성
resource "aws_security_group" "instance" {
  name   = "aws15-terrafrom-example-instance"

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
  default = true
  }

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = ["data.aws_vpc.default.id"]
  }
}

data "template_file" "web_output" {
	template = file("${path.module}/web.sh")
	vars = {
		server_port = "${var.server_port}"
	}
}

