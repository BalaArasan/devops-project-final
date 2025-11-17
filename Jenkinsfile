pipeline {
    agent { label 'docker-agent' }

    environment {
        DEV_REPO = "balaarasan/dev"
        PROD_REPO = "balaarasan/prod"
        BRANCH = "${env.GIT_BRANCH}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Image') {
            steps {
                sh './build.sh'
            }
        }

        stage('Push Image') {
            when {
                anyOf {
                    branch 'dev'
                    branch 'master'
                }
            }
            steps {
                script {
                    if (BRANCH.contains('dev')) {
                        sh "docker push $DEV_REPO:latest"
                    } else if (BRANCH.contains('master')) {
                        sh "docker push $PROD_REPO:latest"
                    }
                }
            }
        }

        stage('Deploy to Server') {
            when {
                branch 'master'
            }
            steps {
                sh './deploy.sh'
            }
        }
    }
}

