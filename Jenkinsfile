pipeline {
    agent any

    environment {
        DOCKER_HUB   = 'srinivasu56'
        IMAGE_NAME   = 'train-ticket-app'
        IMAGE_TAG    = 'latest'
        CONTAINER_NAME = 'train-ticket-app-container'
    }

    stages {

        stage('Clean Workspace') {
            steps {
               sh 'mvn clean package'
            }
        }

        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/Srinivasu2000/movie-ticket-booking-system.git', branch: 'main'
            }
        }

        stage('Build WAR (Maven)') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Verify WAR File') {
            steps {
                sh 'ls -l target/'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_HUB}/${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Docker Login & Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-cred',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS')]) {

                    sh '''
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push ${DOCKER_HUB}/${IMAGE_NAME}:${IMAGE_TAG}
                    '''
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                // Stop and remove previous container if exists
                sh """
                    docker rm -f ${CONTAINER_NAME} || true
                    docker run -d --name ${CONTAINER_NAME} -p 8081:8080 ${DOCKER_HUB}/${IMAGE_NAME}:${IMAGE_TAG}
                """
            }
        }

        stage('Verify Container') {
            steps {
                sh "docker ps -a | grep ${CONTAINER_NAME}"
            }
        }
    }

    post {
        success {
            echo "✅ PIPELINE SUCCESS: Docker image pushed and container running 🚀"
        }
        failure {
            echo "❌ PIPELINE FAILED"
        }
    }
}
