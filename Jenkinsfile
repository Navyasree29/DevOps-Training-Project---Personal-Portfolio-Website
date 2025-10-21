pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'ap-south-1'            // Replace if needed
        ECR_REPO_NAME      = 'capstone-app'         // Replace if needed
        IMAGE_TAG          = 'latest'
        AWS_ACCOUNT_ID     = '390776111022'         // Replace with your AWS Account ID
        EC2_KEY_NAME       = 'capstone-deploy-key'  // Replace with your EC2 Key Pair name
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
                REM Check if ECR repository exists, create if not
                aws ecr describe-repositories --repository-names %ECR_REPO_NAME% --region %AWS_DEFAULT_REGION% || aws ecr create-repository --repository-name %ECR_REPO_NAME% --region %AWS_DEFAULT_REGION%

                REM Login to AWS ECR
                aws ecr get-login-password --region %AWS_DEFAULT_REGION% | docker login --username AWS --password-stdin %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_DEFAULT_REGION%.amazonaws.com

                REM Tag Docker image
                docker tag %ECR_REPO_NAME%:%IMAGE_TAG% %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_DEFAULT_REGION%.amazonaws.com/%ECR_REPO_NAME%:%IMAGE_TAG%

                REM Push Docker image
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
            echo "Pipeline finished successfully! Docker image is in ECR and EC2 should be running."
        }
        failure {
            echo "Pipeline failed. Check the logs for errors."
        }
    }
}
