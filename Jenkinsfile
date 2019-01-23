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
           try {
            sh 'gcloud beta container clusters describe --zone europe-west4-a nexus-cluster-prod2'
        }
        catch (exc) {
            echo 'Something failed, I should sound the klaxons!'
        }
            
            
            steps {
                sh 'gcloud beta container --project "$PROJECT" clusters create "$CLUSTER" --zone "$ZONE" --username "admin" --cluster-version "1.11.6-gke.3" --machine-type "n1-standard-2" --image-type "COS" --disk-type "pd-standard" --disk-size "100" --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "3" --enable-cloud-logging --enable-cloud-monitoring --no-enable-ip-alias --network "projects/$PROJECT/global/networks/default" --subnetwork "projects/$PROJECT/regions/$REGION/subnetworks/default" --addons HorizontalPodAutoscaling,HttpLoadBalancing --enable-autoupgrade --enable-autorepair'
            }
        }
 
         stage('Kubernetes deploy') {
            steps {
                sh 'kubectl apply -f nexus-gce-disk.yaml'
            }
        }

        
        
        
    }
}
