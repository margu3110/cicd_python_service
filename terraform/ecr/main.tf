resource "aws_ecr_repository" "repository" {
  name = "${var.repo_name}"
}