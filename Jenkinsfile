pipeline {
    agent any

    environment {
        AWS_REGION = "ap-northeast-3"
        ECR_REGISTRY = "975050024946.dkr.ecr.ap-northeast-3.amazonaws.com"
        ECR_REPO = "flask-app"
        IMAGE_TAG = "latest"
        CLUSTER_NAME = "flask-eks"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/<YOUR_GITHUB_USERNAME>/<YOUR_REPO>.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                  docker build -t $ECR_REPO:$IMAGE_TAG .
                '''
            }
        }

        stage('Login to ECR') {
            steps {
                sh '''
                  aws ecr get-login-password --region $AWS_REGION | \
                  docker login --username AWS --password-stdin $ECR_REGISTRY
                '''
            }
        }

        stage('Push Image to ECR') {
            steps {
                sh '''
                  docker tag $ECR_REPO:$IMAGE_TAG $ECR_REGISTRY/$ECR_REPO:$IMAGE_TAG
                  docker push $ECR_REGISTRY/$ECR_REPO:$IMAGE_TAG
                '''
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                  kubectl apply -f k8s/
                  kubectl rollout status deployment flask-app
                '''
            }
        }
    }
}
