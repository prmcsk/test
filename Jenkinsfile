pipeline {
    agent any
    
    stages {

       stage('Cleaning up') {
            steps {
                sh 'rm -rf *'
            }
        }
        
       stage('Downloading Maven cache') {
            steps {
                sh 'wget https://storage.googleapis.com/aliz/repository.tar'
            }
        }
        
        stage('Cloning git repo') {
            steps {
                sh 'git clone https://github.com/prmcsk/test.git'
            }
        }     
   }
}
