pipeline {
    agent any
    
    environment {
        PROJECT = 'sdn-controller-001'
  
    }
    
    stages {
        
        stage('Downloading Dockerfile') {
            steps {
                sh 'wget https://storage.googleapis.com/aliz/repository.tar'
            }
        }
              
    }
}
