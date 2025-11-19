pipeline {
    agent any

    environment {
        DH_USER = credentials('dockerhub-creds')
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                sh '''
                    set -e
                    echo "$DH_USER_PSW" | docker login -u "$DH_USER_USR" --password-stdin
                    docker build -t bala1224/dev:latest .
                    docker push bala1224/dev:latest
                '''
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-ssh-key']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ubuntu@43.204.234.83 '
                            echo "Pulling latest Docker image..."
                            docker pull bala1224/dev:latest

                            echo "Stopping old container..."
                            docker rm -f devops-react-app || true

                            echo "Starting new container..."
                            docker run -d -p 80:80 --name devops-react-app bala1224/dev:latest

                            echo "Deployment complete!"
                        '
                    """
                }
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
