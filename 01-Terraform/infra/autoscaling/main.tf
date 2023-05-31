provider "aws" {
  region = "ap-northeast-2"
}


# aws 인스턴스 생성
# aws launch template
resource "aws_launch_template" "example" {
  name                   = "aws15-example"
  image_id               = "ami-0c6e5afdd23291f73"
  instance_type          = "t2.micro"
  key_name               = "aws15-key"
  vpc_security_group_ids = [aws_security_group.instance.id]
  user_data = base64encode(data.template_file.web_output.rendered)
  lifecycle {
    create_before_destroy = true
  }
}



# aws 오토스케일링 그룹 생성
resource "aws_autoscaling_group" "example" {
#  availability_zones = ["ap-northeast-2a", "ap-northeast-2c"]
   vpc_zone_identifier = [var.subnet_public_1, var.subnet_public_2]
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



#인스턴스 보안그룹 생성
resource "aws_security_group" "instance" {
  name = "aws15-terrafrom-example-instance"
  vpc_id = var.vpc_id

  # 인바운드 규칙 설정
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




data "template_file" "web_output" {
  template = file("${path.module}/web.sh")
  vars = {
    server_port = "${var.server_port}"
  }
}


variable "server_port" {
description = "The port the will use for HTTP requests"
type = number
default = 8080
}


variable "vpc_id" {
	default = "<vpc-id>"
}

variable "subnet_public_1" {
  default = "<subnet-id>"
}

variable "subnet_public_2" {
	default = "<subnet-id>"
}

