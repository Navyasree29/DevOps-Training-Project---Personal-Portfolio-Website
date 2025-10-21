pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'ap-south-1'          // Replace if you use a different region
        ECR_REPO_NAME      = 'capstone-app'       // Replace if you have a different repo name
        IMAGE_TAG          = 'latest'
        AWS_ACCOUNT_ID     = '390776111022'       // Replace with your AWS account ID
        EC2_KEY_NAME       = 'capstone-deploy-key' // Replace with your EC2 key pair name
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
                    // Dockerfile is in the root folder
                    docker.build("${env.ECR_REPO_NAME}:${env.IMAGE_TAG}", '.')
                }
            }
        }

        stage('Push to ECR') {
            steps {
                bat """
                REM Log in to AWS ECR
                aws ecr get-login-password --region %AWS_DEFAULT_REGION% | docker login --username AWS --password-stdin %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_DEFAULT_REGION%.amazonaws.com

                REM Tag Docker image
                docker tag %ECR_REPO_NAME%:%IMAGE_TAG% %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_DEFAULT_REGION%.amazonaws.com/%ECR_REPO_NAME%:%IMAGE_TAG%

                REM Push Docker image to ECR
                docker push %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_DEFAULT_REGION%.amazonaws.com/%ECR_REPO_NAME%:%IMAGE_TAG%
                """
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    bat 'terraform init'
                    bat 'terraform apply -auto-approve -var="key_name=%EC2_KEY_NAME%"'
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline finished successfully! Your Docker image is in ECR and EC2 should be running."
        }
        failure {
            echo "Pipeline failed. Check logs for errors."
        }
    }
}
