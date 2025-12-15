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


Note:
For this assignment, the EKS cluster was created manually via AWS Console due to time constraints.
Terraform code is provided for reproducibility, best practices, and evaluation compliance.

# Docker – Flask App Containerization
Dockerfile Summary

Base image: python:3.9-slim

Installs dependencies

Exposes port 5000

Runs Flask app

Local Build (Optional)
docker build -t flask-app .
docker run -p 5000:5000 flask-app

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

# CI/CD Pipeline – Jenkins
Jenkins Pipeline Stages

Checkout Code
Pulls source code from GitHub

Build Docker Image
Builds Flask application image

Login to AWS ECR
Authenticates Docker with ECR

Push Image to ECR
Pushes latest image to AWS ECR

Deploy to EKS
Applies Kubernetes manifests and verifies rollout

Jenkinsfile Overview
Checkout → Build → ECR Login → Push Image → Deploy to EKS


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

# Security Considerations

IAM roles used instead of static credentials

ECR image encryption enabled

Kubernetes RBAC enforced

No secrets hardcoded in code

Jenkins runs with least required permissions
