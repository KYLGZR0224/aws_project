output "vpc_id" {
    value = aws_vpc.project03_vpc.id
}
output "vpc_cidr" {
    value = aws_vpc.project03_vpc.cidr_block
}
output "public_subnet2a" {
    value = aws_subnet.project03_public_subnet2a.id
}
output "public_subnet2c" {
    value = aws_subnet.project03_public_subnet2c.id
}
output "private_subnet2a" {
    value = aws_subnet.project03_private_subnet2a.id
}
output "private_subnet2c" {
    value = aws_subnet.project03_private_subnet2c.id
}
