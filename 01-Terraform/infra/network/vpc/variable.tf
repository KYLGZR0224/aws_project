# vpc 네트워크에 IP 제공 범위 설정

variable "vpc_cidr" {
  default = "10.15.0.0/16"
}


# 퍼블릭 서브넷 설정
variable "public_subnet" {
  type = list
  default = ["10.15.0.0/24", "10.15.16.0/24"]
}

#프라이빗 서브넷 설정
variable "private_subnet" {
  type = list
  default = ["10.15.64.0/24", "10.15.80.0/24"]
}

#가용영역 설정
variable "azs" {
  type = list
  default = ["ap-northeast-2a", "ap-northeast-2c"]
}