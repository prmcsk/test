#!/bin/bash

### Cleaning up screen ###

clear


### Setting general variables ###

START=`date +%s`
GREEN='\033[1;32m'
NC='\033[0m'


### Downloading banner if it does not exists ###

if ! [ -f banner.txt ]; then
  curl -s -o banner.txt https://storage.googleapis.com/aliz/banner.txt
fi


### Downloading Dockerfile if it does not exist ###

if ! [ -f Dockerfile ]; then
  curl -s -o Dockerfile https://storage.googleapis.com/aliz/Dockerfile
fi


### Downloading Kubernetes manifest file if it does not exist ###

if ! [ -f nexus-gce-disk.yaml ]; then
  curl -s -o nexus-gce-disk.yaml https://storage.googleapis.com/aliz/nexus-gce-disk.yaml
fi


### Setting variables for deployment ###

PROJECT=sdn-controller-001
TAG=`cat Dockerfile | sed -n 's/.*ARG TAGVERSION=//p'`
IMAGE=nexus3-custom
GCRIMAGE=gcr.io/$PROJECT/$IMAGE:$TAG
CLUSTER=nexus-cluster-prod
REGION=europe-west4
ZONE=europe-west4-a


### Updating image info in Kubernetes manifest file ###

sed -i 's@gcr.*@'"$GCRIMAGE"'@' nexus-gce-disk.yaml


### Displaying banner ###

cat banner.txt


### Displaying summary info ###

echo
echo "#####################################################"
echo
echo - GCP project id: $PROJECT
echo - Region: $REGION
echo - Zone: $ZONE
echo - Cluster: $CLUSTER
echo - Docker image name and tag: $IMAGE:$TAG
echo
echo "#####################################################"
echo


### Pausing for 5 secs to display summary info ### 

sleep 5


### Enabling Kubernetes Engine API if not enabled ###

if ! gcloud services list --enabled |grep "container.googleapis.com" > /dev/null 2>&1
  then
    echo -e ${GREEN}
    echo -e "### Enabling Kubernetes Engine API ###"
    echo -e ${NC}
    gcloud services enable container.googleapis.com
fi


### Enabling Container Registry API if not enabled ###

if ! gcloud services list --enabled |grep "containerregistry.googleapis.com" > /dev/null 2>&1
  then
    echo -e ${GREEN}
    echo -e "### Enabling Container Registry API ###"
    echo -e ${NC}
    gcloud services enable containerregistry.googleapis.com
fi


### Downloading data for local Maven cache ###

if ! [ -f repository.tar ]; then
  echo -e ${GREEN}
  echo -e "### Downloading for local Maven cache ###"
  echo -e ${NC}
  curl -o repository.tar https://storage.googleapis.com/aliz/repository.tar 
fi


### Building Docker file ###

echo -e ${GREEN}
echo -e "### Building Docker file ###"
echo -e ${NC}
docker build -t $GCRIMAGE -f Dockerfile .


### Authenticating to Docker ###

echo -e ${GREEN}
echo -e "### Authenticating to Docker ###"
echo -e ${NC}
gcloud auth configure-docker --quiet


### Pushing container image to Google Container Registry ###

echo -e ${GREEN}
echo -e "### Pushing container image to Google Container Registry ###"
echo -e ${NC}
docker push $GCRIMAGE


### Creating cluster if it does not exist ###

gcloud beta container clusters describe --zone $ZONE $CLUSTER > /dev/null 2>&1 || { echo -e ${GREEN} && echo -e "### Creating cluster ###" && echo -e ${NC} && \

    gcloud beta container \
	--project "$PROJECT" \
	clusters create "$CLUSTER" \
	--zone "$ZONE" \
	--username "admin" \
	--cluster-version "1.11.6-gke.3" \
	--machine-type "n1-standard-2" \
	--image-type "COS" \
	--disk-type "pd-standard" \
	--disk-size "100" \
	--scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
	--num-nodes "3" \
	--enable-cloud-logging \
	--enable-cloud-monitoring \
	--no-enable-ip-alias \
	--network "projects/$PROJECT/global/networks/default" \
	--subnetwork "projects/$PROJECT/regions/$REGION/subnetworks/default" \
	--addons HorizontalPodAutoscaling,HttpLoadBalancing \
	--enable-autoupgrade \
        --enable-autorepair \
 ;
}

### Deploying Kubernetes manifest file ###

echo -e ${GREEN}
echo -e "### Deploying Kubernetes manifest file ###"
echo -e ${NC}
kubectl apply -f nexus-gce-disk.yaml


### Waiting for LoadBalancer to come up ###

echo
echo -n "Waiting for LoadBalancer to come up..."

while [ "$LBIP" = "" ]
do
  LBIP=`kubectl describe service nexus-service | grep "LoadBalancer Ingress" | awk ' {print $3} '`
  sleep 3
  echo -n "."
done

echo "OK"


### Checking LoadBalancer port ###

LBPORT=`kubectl describe service nexus-service | grep -m 1 "Port" | awk ' {print $3} '`


### Displaying deployment summary ###

echo -e ${GREEN}
echo -e "### Kubernetes deployment complete ###"
echo -e ${NC}

echo -e ${GREEN}
echo -e "### Readyness probe ###"
echo -e ${NC}

echo -n "Waiting for Nexus Repository Manager to come up..."

until curl -s $LBIP -o /dev/null
do
  sleep 3
  echo -n "."
done
echo "OK"

END=`date +%s`

echo -e ${GREEN}
echo -e "#####################################################################################"
echo -e 
echo -e "Your Nexus Repository Manager is available at: http://$LBIP at port: $LBPORT"
echo -e 
echo -e "Version: $TAG"
echo -e 
echo -e "Username: admin"
echo -e 
echo -e "Password: admin123"
echo -e 
echo -e "Absolute path to Google Application Credentials JSON file: /opt/gce-credentials.json"
echo -e 
echo -e "#####################################################################################"
echo -e ${NC}
echo "Automating script completed in $((END-START)) secs."
echo