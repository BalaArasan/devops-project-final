pipeline {
    agent any

    environment {
        DEV_REPO  = "balaarasan12/dev-final"
        PROD_REPO = "balaarasan12/prod-final"
        EC2_IP    = "13.204.66.171"
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

        // ============================
        //   DEV BRANCH ONLY (NO PROD)
        // ============================
        stage('Deploy DEV to EC2') {
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

        // ============================
        //   MAIN BRANCH ONLY (PROD)
        // ============================
        stage('Push PROD Image') {
            when {
                branch 'main'
            }
            steps {
                sh """
                    TAG=\$(date +%Y%m%d%H%M)

                    docker build -t prod-image:\$TAG .
                    docker tag prod-image:\$TAG ${PROD_REPO}:\$TAG
                    docker push ${PROD_REPO}:\$TAG

                    docker tag prod-image:\$TAG ${PROD_REPO}:latest
                    docker push ${PROD_REPO}:latest
                """
            }
        }

        stage('Deploy PROD to EC2') {
            when {
                branch 'main'
            }
            steps {
                sshagent(['ec2-key']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ubuntu@${EC2_IP} '
                            sudo docker pull ${PROD_REPO}:latest &&
                            sudo docker stop final-app || true &&
                            sudo docker rm final-app || true &&
                            sudo docker run -d --name final-app -p 80:80 ${PROD_REPO}:latest
                        '
                    """
                }
            }
        }
    }
}
