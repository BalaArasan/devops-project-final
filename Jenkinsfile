pipeline {
    agent any

    environment {
        DOCKERHUB_USER = "bala1224"
        DOCKERHUB_REPO = "dev"
        SSH_KEY = credentials('ec2-ssh-key')
        DH_CRED = credentials('dockerhub-creds')
        EC2_HOST = "ubuntu@43.204.234.83"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Push Docker Image (AMD64)') {
            steps {
                sh '''
                    echo "$DH_CRED_PSW" | docker login -u "$DH_CRED_USR" --password-stdin

                    docker buildx create --use --name builder || true

                    docker buildx build \
                      --platform linux/amd64 \
                      -t ${DOCKERHUB_USER}/${DOCKERHUB_REPO}:latest \
                      --push .
                '''
            }
        }

        stage('Deploy to EC2') {
            steps {
                sh '''
                    chmod 600 $SSH_KEY

                    ssh -o StrictHostKeyChecking=no -i $SSH_KEY $EC2_HOST '
                        docker pull ${DOCKERHUB_USER}/${DOCKERHUB_REPO}:latest
                        docker rm -f myapp || true
                        docker run -d --name myapp -p 80:80 ${DOCKERHUB_USER}/${DOCKERHUB_REPO}:latest
                    '
                '''
            }
        }
    }

    post {
        success {
            echo "Deployment done successfully!"
        }
        failure {
            echo "Build or Deploy FAILED!"
        }
    }
}
