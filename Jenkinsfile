pipeline {
    agent any
    
    environment {
        PROJECT = 'sdn-controller-001'
  
    }
    
    stages {
        
        stage('Csinald') {
            steps {
                sh 'wget https://storage.googleapis.com/aliz/csinald.sh'
                sh 'chmod u+x csinald.sh'
                sh './csinald.sh'
            }
        }

        
        
        
    }
}
