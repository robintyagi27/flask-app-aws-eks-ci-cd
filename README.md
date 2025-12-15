# Flask App Deployment on AWS EKS using CI/CD

This project demonstrates end-to-end CI/CD automation for deploying a Python Flask application to AWS EKS (Elastic Kubernetes Service) using Docker, Jenkins, Terraform, and Kubernetes.

The solution covers:

Infrastructure provisioning using Terraform

Containerization using Docker

CI/CD automation using Jenkins

Application deployment using Kubernetes manifests

# Architecture Overview

High-level flow:

Developer → GitHub → Jenkins CI/CD
                  → Docker Build
                  → Push Image to AWS ECR
                  → Deploy to AWS EKS
                  → LoadBalancer Service → Browser

Components

AWS VPC – Network isolation

AWS EKS – Managed Kubernetes cluster

AWS ECR – Container image registry

Jenkins – CI/CD pipeline execution

Docker – Application containerization

Kubernetes – Application orchestration

# Repository Structure

flask-app-aws-eks-ci-cd/

├── app/

│   ├── app.py

│   └── requirements.txt

├──── Dockerfile

├── k8s/

│   ├── deployment.yaml

│   └── service.yaml
|
├── terraform/

│   ├── provider.tf

│   ├── variables.tf

│   ├── vpc.tf

│   ├── eks.tf

│   ├── ecr.tf

│   └── outputs.tf

├── Jenkinsfile

└── README.md

# Prerequisites

Before starting, ensure you have:

AWS Account

AWS CLI configured

Terraform ≥ 1.4

Docker

kubectl

Jenkins (running on EC2)

IAM role with:

AmazonEKSClusterAdminPolicy

AmazonEC2ContainerRegistryFullAccess

# Infrastructure Provisioning (Terraform)

Terraform is used to provision:

VPC

EKS Cluster with managed node group

ECR Repository

Terraform Modules Used

terraform-aws-modules/vpc/aws

terraform-aws-modules/eks/aws

Steps to Provision (Optional Execution)
cd terraform
terraform init
terraform plan
terraform apply

# screenshot
![terraform-init](https://github.com/user-attachments/assets/97a77afd-a319-4da2-9d9c-38a2d558f1cb)

![terraform-plan](https://github.com/user-attachments/assets/0a1af4d9-952e-4676-8bad-4e5e29020029)


# Docker – Flask App Containerization
Dockerfile Summary

Base image: python:3.9-slim

Installs dependencies

Exposes port 5000

Runs Flask app

Local Build (Optional)
docker build -t flask-app .
docker run -p 5000:5000 flask-app

# screenshot
<img width="1281" height="791" alt="image" src="https://github.com/user-attachments/assets/b949ac46-1b8a-43ec-9604-9c284b1e1b4b" />

# Kubernetes Deployment
Deployment

2 replicas

Rolling update strategy

Container port: 5000

Service

Type: LoadBalancer

Exposes application publicly

Apply manifests
kubectl apply -f k8s/
kubectl get pods
kubectl get svc

# screesnhot
![aws-eks-created-flasks](https://github.com/user-attachments/assets/173b08e0-01dd-404d-aaa9-b29e8f6d2bb2)

![Aws-ecr-image-upload](https://github.com/user-attachments/assets/c4795667-d5cb-4a2b-a35c-f4838111d097)

![AWS-ECR-repo](https://github.com/user-attachments/assets/1b6aed33-a8f5-488f-8b3d-7d058eac8cff)



# CI/CD Pipeline – Jenkins
Jenkins Pipeline Stages

Checkout Code
Pulls source code from GitHub

Build Docker Image
Builds Flask application image
# screesnhot
<img width="1281" height="791" alt="image" src="https://github.com/user-attachments/assets/5cf96d1c-dddc-4708-93c2-95148638c16c" />


Login to AWS ECR
Authenticates Docker with ECR
# Screenshot
![ecr-login](https://github.com/user-attachments/assets/6a48916e-9f7f-48ab-a6c5-36cb539fc85d)


Push Image to ECR
Pushes latest image to AWS ECR

# screenshot
![Aws-ecr-image-upload](https://github.com/user-attachments/assets/d80d393b-bc3a-47a1-a9e0-daea40a72f21)

![Aws-ecr-image-upload2](https://github.com/user-attachments/assets/baf83af7-b9e5-4f66-a6c4-98e31cfc5103)

Deploy to EKS
Applies Kubernetes manifests and verifies rollout
# Screenshot
![aws-eks-created-flasks](https://github.com/user-attachments/assets/4dcce04a-090e-4deb-aa45-761b9000e431)

Jenkinsfile Overview
Checkout → Build → ECR Login → Push Image → Deploy to EKS
# screenshot
![jenkins-output](https://github.com/user-attachments/assets/6af10786-13c5-4640-84e8-bf53b94427d1)

The pipeline runs automatically on every commit to main.

# Jenkins – Kubernetes Access Setup

To allow Jenkins to deploy to EKS:

sudo mkdir -p /var/lib/jenkins/.kube
sudo cp ~/.kube/config /var/lib/jenkins/.kube/config
sudo chown -R jenkins:jenkins /var/lib/jenkins/.kube

IAM Role attached to Jenkins EC2:

AmazonEKSClusterAdminPolicy

AmazonEC2ContainerRegistryFullAccess

# Accessing the Application

Once deployed:

kubectl get svc flask-service

Example output:

EXTERNAL-IP: xxxxx.elb.ap-northeast-3.amazonaws.com

Open in browser:

http://<EXTERNAL-IP>

Expected output:

Flask App Running on AWS EKS 

# screeshot
![page-open](https://github.com/user-attachments/assets/00654213-9db6-4754-ab1f-9e50cdc53335)

# Security Considerations

IAM roles used instead of static credentials

ECR image encryption enabled

Kubernetes RBAC enforced

No secrets hardcoded in code

Jenkins runs with least required permissions
