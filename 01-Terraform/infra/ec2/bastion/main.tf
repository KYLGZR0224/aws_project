resource "aws_instance" "project03_bastion" {
    ami = data.aws_ami.ubuntu.image_id
    instance_type = "t2.micro"
    key_name = "aws15-home-key"
    vpc_security_group_ids = [aws_security_group.project03_ssh_sg.id]
    subnet_id = data.terraform_remote_state.project03_vpc.outputs.public_subnet2a
    availability_zone = "ap-northeast-2a"
    associate_public_ip_address = true

    tags = {
        Name = "project03-bastion"
    }
}

resource "aws_security_group" "project03_ssh_sg" {
    name        = "project03_ssh_sg"
    description = "security group for ssh server"
    vpc_id      = data.terraform_remote_state.project03_vpc.outputs.vpc_id

    ingress {
        description = "For ssh port"
        from_port   = 22
        to_port     = 22
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
        Name = "project03_ssh_sg"
    }
}