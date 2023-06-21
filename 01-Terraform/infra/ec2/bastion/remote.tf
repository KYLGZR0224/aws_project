
data "terraform_remote_state" "aws15_vpc" {
    backend = "s3"
    config = {
      bucket = "aws00-terraform-state"
      key    = "infra/network/vpc/terraform.tfstate"   # 가져와야하는 상태코드 위치
      region = "ap-northeast-2"                        # 나중에는 이걸 변수로 가져와야
    
    }
}

# 어떤 자료가 필요해서 가져오는 명령?
# 다른상태 코드로 부터 데이터를 가져올때