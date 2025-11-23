pipeline {
    agent any

    environment {
        DEV_REPO = "balaarasan12/dev-final"
        PROD_REPO = "balaarasan12/prod-final"
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

        stage('Deploy to EC2') {
            steps {
                sh """
                    echo "Deploying image: balaarasan12/dev-final:latest"
                    sudo docker pull balaarasan12/dev-final:latest
                    sudo docker stop final-app || true
                    sudo docker rm final-app || true
                    sudo docker run -d --name final-app -p 80:80 balaarasan12/dev-final:latest
                """
            }
        }

    }
}
