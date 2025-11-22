pipeline {
    agent any

    environment {
        DOCKER_DEV_REPO = "balaarasan12/dev-final"
        DOCKER_PROD_REPO = "balaarasan12/prod-final"
        IMAGE_TAG = "${env.BRANCH_NAME}-${env.BUILD_NUMBER}"
    }

    stages {

        stage('Build Docker Image') {
            steps {
                sh '''
                echo "⏳ BUILD STAGE STARTED"
                chmod +x build.sh
                ./build.sh
                '''
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    if (env.BRANCH_NAME == "dev") {
                        sh """
                        echo "🚀 Pushing DEV image..."
                        docker tag devops-final-app:${IMAGE_TAG} ${DOCKER_DEV_REPO}:${IMAGE_TAG}
                        docker push ${DOCKER_DEV_REPO}:${IMAGE_TAG}
                        echo "DEV push complete."
                        """
                    } else if (env.BRANCH_NAME == "main") {
                        sh """
                        echo "🚀 Pushing PROD image..."
                        docker tag devops-final-app:${IMAGE_TAG} ${DOCKER_PROD_REPO}:${IMAGE_TAG}
                        docker push ${DOCKER_PROD_REPO}:${IMAGE_TAG}
                        echo "PROD push complete."
                        """
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            when { branch "main" }
            steps {
                sh '''
                echo "📦 Deploying to EC2 Production Server..."
                chmod +x deploy.sh
                ./deploy.sh
                '''
            }
        }
    }

    post {
        success {
            echo "🎉 Pipeline completed successfully for branch: ${env.BRANCH_NAME}"
        }
        failure {
            echo "❌ Pipeline FAILED — check logs!"
        }
    }
}
