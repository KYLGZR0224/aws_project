output "vpc_id" {
   value = aws_vpc.aws15_vpc.id
}
# 여기에 .id가 왜 붙는지 알아봐야 함

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