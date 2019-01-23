pipeline {
    agent any
    
    environment {
        PROJECT=sdn-controller-001
    
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
      
        stage('ENV test') {
            steps {
                sh 'echo $PROJECT >> project.txt'
            }
        }

        
        
        
    }
}
