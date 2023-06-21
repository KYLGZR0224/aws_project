resource "aws_instance" "aws15_bastion" {
     ami = data.aws_ami.ubuntu.image_id
     instance_type = "t2.micro"
     key_name = "aws15-key"
     vpc_security_group_ids = [aws_security_group.aws15_ssh_sg.id]          #보안 그룹
     subnet_id = data.terraform_remote_state.aws15_vpc.outputs.public_subnet2a        # 서브넷
     availability_zone = "ap-northeast-2a"            #가용 영역
     associate_public_ip_address = true               # 퍼블릭 IP 할당 여부

     tags = {
           Name = "aws15-bastion"
     }
}

resource "aws_security_group" "aws15_ssh_sg" {
   
     name = "aws15_ssh_sg"
     description = "security group for ssh server"
     vpc_id = data.terraform_remote_state.aws15_vpc.outputs.vpc_id 

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