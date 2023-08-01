provider "aws" {
  region = "ap-northeast-2"
}
# AWS ◀◀◀◀◀◀◀◀인스턴스 생성▶▶▶▶▶▶▶▶
# AWS launch configuration create
resource "aws_launch_template" "example" {
  name                   = "project03-example"
  image_id               = "ami-0c6e5afdd23291f73"
  instance_type          = "t2.micro"
  key_name               = "aws15-home-key"
  vpc_security_group_ids = [aws_security_group.project03_web_sg.id]

  user_data = base64encode(data.template_file.web_output.rendered)

  lifecycle {
    create_before_destroy = true
  }
}

# AWS ◀◀◀◀◀◀◀◀auto scaling group create▶▶▶▶▶▶▶▶
resource "aws_autoscaling_group" "example" {
  availability_zones = ["ap-northeast-2a", "ap-northeast-2c"]

  name             = "project03-terraform-asg-example"
  desired_capacity = 1
  min_size         = 1
  max_size         = 2

  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"

  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "project03-terraform-asg-example"
    propagate_at_launch = true
  }
}

# ◀◀◀◀◀◀◀◀Application Load Balance▶▶▶▶▶▶▶▶
resource "aws_lb" "example" {
  name               = "project03-terraform-alb-example"
  load_balancer_type = "application"
  # 로드밸런스 생성되는 vpc의 서브넷
  subnets = data.aws_subnets.default.ids
  # 로드밸런스에 사용할 보안 그룹 
  security_groups = [aws_security_group.project03_web_sg.id]
}

# ALB 리스너
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port              = 80
  protocol          = "HTTP"

  # 기본값으로 단순한 404 페이지 오류를 반환한다.
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}
# ALB 리스너 규칙
resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}

# ALB 대상 그룹
resource "aws_lb_target_group" "asg" {
  name     = "project03-terraform-asg-example"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.project03_vpc.id
# 대상그룹의 상태검사
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_security_group" "project03_ssh_sg" {
    name        = "project03_ssh_sg"
    description = "security group for ssh server"
    vpc_id      = data.terraform_remote_state.project03_vpc.outputs.vpc_id

  # 인바운드 HTTP 트래픽 허용
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # 모든 아웃바운드 트래픽 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "project03_web_sg" {
    name        = "project03_web_sg"
    description = "security group for web server"
    vpc_id      = data.terraform_remote_state.project03_vpc.outputs.vpc_id

  # 인바운드 HTTP 트래픽 허용
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # 모든 아웃바운드 트래픽 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_vpc" "project03_vpc" {
  # 이름이 "asdf12345-vpc"인 VPC를 가져오도록 설정합니다.
  filter {
    name   = "tag:Name"
    values = ["project03_vpc"]
  }
}
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.project03_vpc.id]
  }
}

data "template_file" "web_output" {
  template = file("${path.module}/web.sh")
  vars = {
    server_port = "${var.server_port}"
  }
}

variable "server_port" {
  description = "The port will use for HTTP requests"
  type        = number
  default     = 8080
}