pipeline {
    agent any
    def app
    
    environment {
        PROJECT = 'sdn-controller-001'
  
    }
    
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
      
    stage('Build image') {
        /* This builds the actual image; synonymous to
         * docker build on the command line */

        app = docker.build("getintodevops/hellonode")
    }

 
        
        
    }
}
