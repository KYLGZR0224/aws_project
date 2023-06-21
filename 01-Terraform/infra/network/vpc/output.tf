output "vpc_id" {
   value = aws_vpc.aws15_vpc.id
}

# vpc id를 아웃풋 하여 상태코드를 공유
# 다른 작업에 필요한 것을 미리 아웃풋으로 공유 해줘야 한다

# 여기에 .id가 왜 붙는지 알아봐야 함 해결됨 의미 없음


# 퍼블릭 네트워크 2개에 대한 서브넷 아이디를 아웃풋 상태코드를 공유
output "public_subnet2a" {
   value = aws_subnet.aws15_public_subnet2a.id
}

output "public_subnet2c" {
   value = aws_subnet.aws15_public_subnet2c.id
}



# 프라이빗 네트워크 2개에 대한 서브넷 아이디를 아웃풋 상태코드를 공유
output "private_subnet2a" {
   value = aws_subnet.aws15_private_subnet2a.id
}

output "private_subnet2c" {
   value = aws_subnet.aws15_private_subnet2c.id
}



# output "public_subnet_arns" {
#     value = aws_vpc.aws15_vpc.public_subnet_arns
# }

# output "public_subnet_ids" {
#     value = aws_vpc.aws15_vpc.public_subnet
# }


# output "private_subnet_arns" {
#     value = aws_vpc.aws15_vpc.private_subnet_arns
# }

# output "private_subnet_ids" {
#     value = aws_vpc.aws15_vpc.private_subnet
# }

# aws15_public_subnet2a