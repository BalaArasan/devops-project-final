pipeline {
    agent any

    environment {
        // these are injected by Jenkins when you add credentials with these IDs
        SSH_KEY = credentials('ec2-ssh-key')
        DH_CRED = credentials('dockerhub-creds')
        DOCKERHUB_USER = "bala1224"
        DOCKERHUB_REPO = "dev"
        EC2_HOST = "ubuntu@43.204.234.83"
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
                    echo "$DH_CRED_PSW" | docker login -u "$DH_CRED_USR" --password-stdin
                    docker build -t ${DOCKERHUB_USER}/${DOCKERHUB_REPO}:latest .
                    docker push ${DOCKERHUB_USER}/${DOCKERHUB_REPO}:latest
                '''
            }
        }

        stage('Deploy to EC2') {
            steps {
                // use sshagent so Jenkins injects the private key properly
                sshagent(credentials: ['ec2-ssh-key']) {
                    sh '''
                        set -e
                        ssh -o StrictHostKeyChecking=no ${EC2_HOST} <<'REMOTE'
                            set -e
                            echo "Pulling latest Docker image..."
                            docker pull ${DOCKERHUB_USER}/${DOCKERHUB_REPO}:latest

                            echo "Stopping old container (if exists)..."
                            docker rm -f devops-react-app || true

                            echo "Starting new container..."
                            docker run -d -p 80:80 --name devops-react-app ${DOCKERHUB_USER}/${DOCKERHUB_REPO}:latest

                            echo "Deployment finished on EC2."
                        REMOTE
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "Build and Deploy SUCCESSFUL!"
        }
        failure {
            echo "Build or Deploy FAILED!"
        }
    }
}
