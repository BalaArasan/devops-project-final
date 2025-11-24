pipeline {
    agent any

    environment {
        DEV_REPO = "balaarasan12/dev-final"
        EC2_IP   = "13.204.66.171"
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

        stage('Deploy to EC2 (DEV)') {
            when {
                branch 'dev'
            }
            steps {
                sh """
                    echo "Deploying DEV image: ${DEV_REPO}:latest"

                    sudo docker pull ${DEV_REPO}:latest
                    sudo docker stop final-app || true
                    sudo docker rm final-app || true
                    sudo docker run -d --name final-app -p 80:80 ${DEV_REPO}:latest
                """
            }
        }
    }

    post {
        success {
            echo "Build & Deploy Successful!"
        }
        failure {
            echo "Build or Deploy FAILED!"
        }
    }
}
