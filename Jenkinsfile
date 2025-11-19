pipeline {
    agent any

    environment {
        SSH_KEY = credentials('ec2-ssh-key')
        DH_CRED = credentials('dockerhub-creds')
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
                    echo "$DH_CRED_PSW" | docker login -u "$DH_CRED_USR" --password-stdin
                    
                    # Build Docker image (NO buildx)
                    docker build -t bala1224/dev:latest .
                    
                    # Push image to DockerHub
                    docker push bala1224/dev:latest
                '''
            }
        }

        stage('Deploy to EC2') {
            steps {
                sh '''
                    echo "Deploying to EC2..."

                    ssh -o StrictHostKeyChecking=no -i $SSH_KEY ubuntu@43.204.234.83 '
                        echo "Pulling latest Docker image..."
                        docker pull bala1224/dev:latest

                        echo "Stopping old container (if exists)..."
                        docker rm -f devops-react-app || true

                        echo "Starting new container..."
                        docker run -d -p 80:80 --name devops-react-app bala1224/dev:latest

                        echo "Deployment complete!"
                    '
                '''
            }
        }
    }

    post {
        failure {
            echo "Build or Deploy FAILED!"
        }
        success {
            echo "Build and Deploy SUCCESSFUL!"
        }
    }
}
