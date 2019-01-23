pipeline {
    agent any
    
    stages {

       stage('Cleaning up') {
            steps {
                sh 'rm Dockerf*'
            }
        }
        
        
       stage('Downloading Dockerfile cache') {
            steps {
                sh 'wget https://storage.googleapis.com/aliz/Dockerfile'
            }
        }

        stage('Docker build') {
            steps {
                sh 'docker build -t nexus .'
            }
        }
        
        
    }
}
