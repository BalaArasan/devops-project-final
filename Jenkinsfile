pipeline {
    agent any

    environment {
        DEV_REPO = "balaarasan/dev-final"
        PROD_REPO = "balaarasan/prod-final"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'dev', url: 'https://github.com/BalaArasan/devops-project-final.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "./build.sh"
            }
        }

        stage('Push to Prod on Merge') {
            when {
                branch 'main'
            }
            steps {
                sh """
                   TAG=$(date +%Y%m%d%H%M)
                   docker build -t prod-image:$TAG .
                   docker tag prod-image:$TAG $PROD_REPO:$TAG
                   docker push $PROD_REPO:$TAG
                """
            }
        }

        stage('Deploy to EC2') {
            when {
                branch 'main'
            }
            steps {
                sshagent(['ec2-key']) {
                    sh "ssh -o StrictHostKeyChecking=no ubuntu@YOUR_EC2_IP 'bash -s' < deploy.sh latest"
                }
            }
        }
    }
}
