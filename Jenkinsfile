pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/12ashok/maha'
            }
        }

        stage('Build JAR') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t webpage:0.0.1 .'
            }
        }

        stage('Cleanup container') {
            steps {
                sh 'docker rm -f myapp-container || true'
            }
        }

        stage('Run Docker Container') {
            steps {
                sh '''
                    docker rm -f myapp-container || true
                    docker run -d -p 80:80 --name myapp-container webpage:0.0.1
                '''
            }
        }
    }
}
