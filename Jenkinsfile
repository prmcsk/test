pipeline {
    agent any
    
     environment {
        PROJECT = 'sdn-controller-001'
        TAG = '3.15.0'
        IMAGE = 'nexus3-custom'
        GCRIMAGE = "gcr.io/$PROJECT/$IMAGE:$TAG"
        CLUSTER = 'nexus-cluster-prod'
        REGION = 'europe-west4'
        ZONE = 'europe-west4-a'
  
    }
    
    stages {

       stage('Cleaning up') {
            steps {
                sh 'rm Dockerf*'
                sh 'rm gce-cred*'
                sh 'rm nexus-gce*'
            }
        }
                
       stage('Downloading Dockerfile') {
            steps {
                sh 'wget https://raw.githubusercontent.com/prmcsk/test/master/Dockerfile'
                sh 'wget https://raw.githubusercontent.com/prmcsk/test/master/nexus-gce-disk.yaml'
                sh 'wget https://storage.googleapis.com/aliz/gce-credentials.json'
            }
        }
        
        stage('Docker build') {
            steps {
                sh 'docker build -t $GCRIMAGE -f Dockerfile .'
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
                sh 'docker push $GCRIMAGE'
            }
        }
        
        stage('Create cluster') {         

            steps {
                sh (script: 'gcloud beta container clusters describe --zone europe-west4-a nexus-cluster-prod', returnStdout: true)
                
            }
        }
            
                            
            
 
         stage('Kubernetes deploy') {
            steps {
                sh 'echo "Kubernetes"'
            }
        }

        
        
        
    }
}
