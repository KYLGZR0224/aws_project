terraform {
  backend "s3" {
    # 이전에 생성한 버킷 이름으로 변경
    bucket = "aws15-terraform-state"
    key    = "infra/network/vpc/terraform.tfstate"
    region = "ap-northeast-2"

    # 이전에 생성한 다이나모DB 테이블 이름으로 변경
    dynamodb_table = "aws15-terraform-locks"
    encrypt        = true
  }
}