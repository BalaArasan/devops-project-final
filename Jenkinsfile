pipeline {
  agent any

  environment {
    DEV_REPO  = "balaarasan12/dev-final"
    PROD_REPO = "balaarasan12/prod-final"
    EC2_IP    = "3.108.91.6"          // <-- change if needed
  }

  stages {

    stage('Checkout') {
      steps {
        git branch: 'dev', url: 'https://github.com/BalaArasan/devops-project-final.git'
      }
    }

    stage('Ensure Docker access') {
      steps {
        // This is a no-op when Jenkins runs inside a container with proper socket bind+groups.
        // It prints diagnostic info so you can debug permissions quickly.
        sh '''
          echo "===== DOCKER SOCKET ====="
          ls -l /var/run/docker.sock || true
          echo "===== DOCKER VERSION (host) ====="
          docker --version || true
          echo "===== WHOAMI INSIDE AGENT ====="
          id || true
        '''
      }
    }

    stage('Build & Push Docker Image') {
      steps {
        // Use credential id 'dockerhub-creds' created in Jenkins GUI (username:balaarasan12, password:token)
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DH_USER_USR', passwordVariable: 'DH_USER_PSW')]) {
          sh '''
            set -e
            echo "Logging into Docker Hub..."
            echo "$DH_USER_PSW" | docker login -u "$DH_USER_USR" --password-stdin

            TAG=$(date +%Y%m%d%H%M)
            echo "Building image ${DEV_REPO}:$TAG"
            docker build -t ${DEV_REPO}:$TAG .

            echo "Tagging latest..."
            docker tag ${DEV_REPO}:$TAG ${DEV_REPO}:latest

            echo "Pushing tags..."
            docker push ${DEV_REPO}:$TAG
            docker push ${DEV_REPO}:latest

            echo "Build & push done: ${DEV_REPO}:$TAG"
          '''
        }
      }
    }

    stage('Deploy DEV to EC2') {
      when { branch 'dev' }
      steps {
        // Uses Jenkins credential (SSH key) with id 'ec2-key' (add via Jenkins Credentials > SSH username with private key)
        sshagent(['ec2-key']) {
          sh """
            echo "Deploying ${DEV_REPO}:latest to ${EC2_IP}"
            ssh -o StrictHostKeyChecking=no ubuntu@${EC2_IP} '
              set -e
              echo "Pulling image..."
              sudo docker pull ${DEV_REPO}:latest
              echo "Stopping old container..."
              sudo docker rm -f final-app || true
              echo "Starting new container..."
              sudo docker run -d --name final-app -p 80:80 ${DEV_REPO}:latest
              echo "Deployed ${DEV_REPO}:latest"
            '
          """
        }
      }
    }

    stage('Build & Push PROD Image') {
      when { branch 'main' }
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DH_USER_USR', passwordVariable: 'DH_USER_PSW')]) {
          sh '''
            set -e
            echo "$DH_USER_PSW" | docker login -u "$DH_USER_USR" --password-stdin
            TAG=$(date +%Y%m%d%H%M)
            docker build -t prod-image:$TAG .
            docker tag prod-image:$TAG ${PROD_REPO}:$TAG
            docker push ${PROD_REPO}:$TAG
            docker tag prod-image:$TAG ${PROD_REPO}:latest
            docker push ${PROD_REPO}:latest
          '''
        }
      }
    }

    stage('Deploy PROD to EC2') {
      when { branch 'main' }
      steps {
        sshagent(['ec2-key']) {
          sh """
            ssh -o StrictHostKeyChecking=no ubuntu@${EC2_IP} '
              set -e
              sudo docker pull ${PROD_REPO}:latest
              sudo docker rm -f final-app || true
              sudo docker run -d --name final-app -p 80:80 ${PROD_REPO}:latest
            '
          """
        }
      }
    }
  } // stages

  post {
    success { echo "Pipeline succeeded." }
    failure { echo "Pipeline failed — check console output." }
  }
}
