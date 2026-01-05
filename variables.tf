variable "region" {
  description = "AWSリージョン"
  default     = "ap-northeast-1"
}

variable "project_name" {
  description = "プロジェクト名"
  default     = "test-igarashi"
}

variable "vpc_cidr" {
  description = "VPC全体のCIDR"
  default     = "10.0.0.0/16"
}

# 1層目: パブリック (ALB, NAT用)
variable "public_subnet_cidrs" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

# 2層目: プロテクテッド 
variable "protected_subnet_cidrs" {
  default = ["10.0.10.0/24", "10.0.11.0/24"]
}

# 3層目: プライベート 
variable "private_subnet_cidrs" {
  default = ["10.0.20.0/24", "10.0.21.0/24"]
}

variable "instance_type" {
  description = "EC2インスタンスタイプ"
  default     = "t2.micro"
}

variable "server_names" {
  type    = list(string)
  default = ["test-igarashi-1", "test-igarashi-2"]
}