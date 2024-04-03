#!/bin/bash
sudo yum update –y

# Install docker
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user

# Install aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Install git
sudo yum install git

# Clone the repository from github
git clone git@github.com:margu3110/cicd_python_service.git

# Build the docker image
cd cicd_python_service
docker build --tag "counter-service-local:1.0.0" .;

# Login to the AWS ECR repository
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 767398132115.dkr.ecr.region.amazonaws.com


