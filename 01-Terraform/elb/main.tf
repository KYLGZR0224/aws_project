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
  availability_zones = ["ap-northeast-2a", "ap-northeast-2c"]
  name             = "aws15-terraform-asg-example"
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
    value               = "aws15-terraform-asg-example"
    propagate_at_launch = true
  }
}



#Application Load Balancer
resource "aws_lb" "example" {
  name              = "aws15-terraform-alb-example"
  load_balancer_type = "application"
  subnets           = data.aws_subnets.default.ids
  security_groups   = [aws_security_group.alb.id]
}



# 로드밸런서 리스너 
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


# 로드밸런서 리스너 규칙
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



# ALB target group  대상그룹 생성
resource "aws_lb_target_group" "asg" {
  name     = "aws15-terraform-asg-example"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
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



#어플리케이션 로드밸런서 보안그룹
resource "aws_security_group" "alb" {
  name = "aws15-terraform-alb-example"

  # 인바운드 HTTP 트래픽 허용
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




#인스턴스 보안그룹 생성
resource "aws_security_group" "instance" {
  name = "aws15-terrafrom-example-instance"

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

