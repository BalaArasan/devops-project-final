pipeline {
    agent any

    environment {
        DEV_REPO  = "balaarasan12/dev-final"
        EC2_IP    = "3.108.91.6"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'dev', url: 'https://github.com/BalaArasan/devops-project-final.git'
            }
        }

        stage('Fix Docker Permission (Inside Jenkins Container)') {
            steps {
                sh '''
                    echo "Fixing Docker permission for Jenkins user..."
                    sudo usermod -aG docker jenkins || true
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    chmod +x build.sh
                    ./build.sh
                '''
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
                                                 usernameVariable: 'DH_USER',
                                                 passwordVariable: 'DH_PASS')]) {
                    sh '''
                        echo "$DH_PASS" | docker login -u "$DH_USER" --password-stdin
                        docker push $DEV_REPO:latest
                    '''
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-key']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ubuntu@${EC2_IP} '
                            sudo docker pull ${DEV_REPO}:latest &&
                            sudo docker stop final-app || true &&
                            sudo docker rm final-app || true &&
                            sudo docker run -d --name final-app -p 80:80 ${DEV_REPO}:latest
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
            echo "Build FAILED — fix errors above."
        }
    }
}
