data "aws_vpc" "default_vpc" {
  default = true
} 

#Create security group for EC2 server
### Security Group Module
module "service_sg" {
    source = "./sg"
    appName = "counter"
    vpc_id = data.aws_vpc.default_vpc.id
}

# Terraform module Block to create the iam instance profile
module "iam_instance_profile" {
  source        = "./iam"
  instance_profile_name = "instance-profile-devops"
  secrets_iam_policy_name = "secrets-policy"
  ecr_iam_policy_name = "ecr-policy"
  role_name = "role_name"
}

# Terraform module Block to create the ecr repository
module "ecr_repository" {
  source        = "./ecr"
  repo_name      = "counter_service"
}

# Terraform module Block to create EC2 Server
module "ec2" {
  source        = "./ec2"
  ec2_name      = "counter"
  key_name      = "isildur"
  ami           = "ami-0e1d30f2c40c4c701"
  instance_type = "t2.micro"
  vpc_sg        = module.service_sg.service_sg_id
  instance_profile = module.iam_instance_profile.instance_profile
}

data "aws_caller_identity" "current" {}