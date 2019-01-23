pipeline {
    agent any
    
    environment {
        PROJECT = 'sdn-controller-001'
        TAG = `cat Dockerfile | sed -n 's/.*ARG TAGVERSION=//p'`
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
      
        stage('ENV test 2') {
            steps {
                sh 'echo $TAG >> tag.txt'
            }
        }

        
        
        
    }
}
