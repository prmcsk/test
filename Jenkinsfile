pipeline {
    agent any
    
     environment {
        PROJECT = 'sdn-controller-001'
        TAG = 'latest'
        IMAGE = 'nexus3-custom'
        GCRIMAGE = "gcr.io/$PROJECT/$IMAGE:$TAG"
        SCLUSTER = 'nexus-cluster-stage'
        PCLUSTER = 'nexus-cluster-prod'
        REGION = 'europe-west4'
        ZONE = 'europe-west4-a'
        STAGING = "gke_${PROJECT}_${ZONE}_${SCLUSTER}"
        PRODUCTION = "gke_${PROJECT}_${ZONE}_${PCLUSTER}"
  
    }
    
    stages {
        
        stage('Build') {
            
            when {
                branch 'master'
            }
                                  
            steps {
               
                echo 'Downloading Dockerfile, Kubernetes manifest file, Service Account key file, Maven cache'
                sh 'wget -O Dockerfile https://raw.githubusercontent.com/prmcsk/test/master/Dockerfile && wget -O nexus-gce-disk.yaml https://raw.githubusercontent.com/prmcsk/test/master/nexus-gce-disk.yaml && wget -O gke-003-credentials.json https://storage.googleapis.com/aliz/gke-003-credentials.json && wget -nc -O repository.tar https://storage.googleapis.com/aliz/repository.tar || true'
                
                echo 'Docker build'
                sh 'docker build -t $GCRIMAGE -f Dockerfile .'
                
                echo 'GKE authentication'
                sh 'gcloud auth activate-service-account --key-file=gke-003-credentials.json'
                
                echo 'GCR authentication'
                sh 'gcloud auth configure-docker --quiet'
                
                echo 'Container push'
                sh 'docker push $GCRIMAGE'
                
                echo 'Creating staging cluster'
                sh 'gcloud beta container --project "$PROJECT" clusters create "$SCLUSTER" --zone "$ZONE" --username "admin" --cluster-version "1.11.6-gke.3" --machine-type "n1-standard-2" --image-type "COS" --disk-type "pd-standard" --disk-size "100" --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "3" --enable-cloud-logging --enable-cloud-monitoring --no-enable-ip-alias --network "projects/$PROJECT/global/networks/default" --subnetwork "projects/$PROJECT/regions/$REGION/subnetworks/default" --addons HorizontalPodAutoscaling,HttpLoadBalancing --enable-autoupgrade --enable-autorepair || true'
                
                echo 'Fetching staging cluster endpoint and auth data'
                sh 'gcloud beta container clusters get-credentials --zone=$ZONE --project=$PROJECT $SCLUSTER'
                
                echo 'Creating production cluster'
                sh 'gcloud beta container --project "$PROJECT" clusters create "$PCLUSTER" --zone "$ZONE" --username "admin" --cluster-version "1.11.6-gke.3" --machine-type "n1-standard-2" --image-type "COS" --disk-type "pd-standard" --disk-size "100" --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "3" --enable-cloud-logging --enable-cloud-monitoring --no-enable-ip-alias --network "projects/$PROJECT/global/networks/default" --subnetwork "projects/$PROJECT/regions/$REGION/subnetworks/default" --addons HorizontalPodAutoscaling,HttpLoadBalancing --enable-autoupgrade --enable-autorepair || true'
                
                echo 'Fetching production cluster endpoint and auth data'
                sh 'gcloud beta container clusters get-credentials --zone=$ZONE --project=$PROJECT $PCLUSTER'
                
            }
        }
            
        stage('Deploy to staging cluster') {
             
             when {
                branch 'master'
            }
             
             steps {
                 
                echo 'Kubernetes deploy to staging cluster'
                sh 'kubectl apply -f nexus-gce-disk.yaml --cluster=$STAGING'
                 
              }
         }
                   
         stage('Deploy to production cluster') {
             
             when {
                branch 'master'
             }
                                                     
             steps {
                 input 'Deploy to production?'
                 milestone (1)
                                 
                 echo 'Kubernetes deploy to production cluster'
                 sh 'kubectl apply -f nexus-gce-disk.yaml --cluster=$PRODUCTION'
             }
         }
    }
}
