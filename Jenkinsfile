pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'ap-south-1'  
        ECR_REPO_NAME      = 'capstone-app'
        IMAGE_TAG          = 'latest'
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Navyasree29/CapstoneProject-JADT.git', branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${env.ECR_REPO_NAME}:${env.IMAGE_TAG}", '.')
                }
            }
        }

        stage('Push to ECR') {
            steps {
                script {
                    sh '''
                    aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin 390776111022.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com
                    docker tag ${ECR_REPO_NAME}:${IMAGE_TAG} 390776111022.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${ECR_REPO_NAME}:${IMAGE_TAG}
                    docker push 390776111022.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${ECR_REPO_NAME}:${IMAGE_TAG}
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve -var="key_name=capstone-deploy-key"'
                }
            }
        }
    }
}
