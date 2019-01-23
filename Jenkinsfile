pipeline {
    agent any
    
    stages {

       stage('Cleaning up') {
            steps {
                sh 'rm Dockerfile'
            }
        }
                
       stage('Downloading Dockerfile') {
            steps {
                sh 'wget https://storage.googleapis.com/aliz/Dockerfile'
            }
        }

        stage('Downloading GCE Keyfile') {
            steps {
                sh 'wget https://storage.googleapis.com/aliz/gce-credentials.json'
            }
        }
        
        stage('Docker build') {
            steps {
                sh 'docker build -t nexus .'
            }
        }
        
        stage('GCE authentication') {
            steps {
                sh 'gcloud auth activate-service-account --key-file=gce-credentials.json'
            }
        }

        stage('GCR authentication') {
            steps {
                sh 'gcloud auth configure-docker --quiet'
            }
        }

        
        
        
        
        
        
    }
}
