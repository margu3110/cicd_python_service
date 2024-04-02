variable "instance_profile_name" {
  type    = string
  default = "instance-profile-devops"
}

variable "secrets_iam_policy_name" {
  type    = string
  default = "secrets-policy"
}

variable "ecr_iam_policy_name" {
  type    = string
  default = "ecr-policy"
}

variable "role_name" {
  type    = string
  default = "devops-role"
}