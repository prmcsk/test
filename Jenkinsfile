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
                sh 'docker build -t gcr.io/sdn-controller-001/nexus3-custom:latest .'
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

         stage('Container push') {
            steps {
                sh 'docker push gcr.io/sdn-controller-001/nexus3-custom:latest'
            }
        }
        
        
        
        
        
        
    }
}
