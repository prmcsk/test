pipeline {
    agent any
    stages {
        
        stage('Downloading Dockerfile') {
            steps {
                sh 'wget https://storage.googleapis.com/aliz/Dockerfile'
            }
        }
        
        stage('Downloading Kubernetes manifest file') {
            steps {
                sh 'wget https://storage.googleapis.com/aliz/nexus-gce-disk.yaml'
            }
        }
        
        
        
        
    }
}
