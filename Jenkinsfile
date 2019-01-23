pipeline {
    agent any
    
    stages {

       stage('Cleaning up') {
            steps {
                sh 'rm Dockerf*'
                sh 'rm repo*'
            }
        }
        
       stage('Downloading Maven cache') {
            steps {
                sh 'wget https://storage.googleapis.com/aliz/repository.tar'
            }
        }
        
       stage('Downloading Dockerfile cache') {
            steps {
                sh 'wget https://storage.googleapis.com/aliz/Dockerfile'
            }
        }

    }
}
