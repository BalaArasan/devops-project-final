pipeline {
    agent any

    environment {
        DEV_REPO  = "balaarasan12/dev-final"
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

        stage('Push Image to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh """
                        echo "$PASS" | docker login -u "$USER" --password-stdin
                        docker push ${DEV_REPO}:latest
                    """
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sh """
                    sudo docker pull ${DEV_REPO}:latest
                    sudo docker stop final-app || true
                    sudo docker rm final-app || true
                    sudo docker run -d --name final-app -p 80:80 ${DEV_REPO}:latest
                """
            }
        }
    }
}
