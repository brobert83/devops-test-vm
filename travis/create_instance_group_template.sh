#!/bin/bash

project=workshop-devops-test
template_name=instance-template-1
service_account_email=292286721672-compute@developer.gserviceaccount.com

gcloud beta compute \
   --project=${project} instance-templates create ${template_name} \
   --machine-type=e2-micro \
   --network=projects/${project}/global/networks/default \
   --network-tier=PREMIUM \
   --maintenance-policy=MIGRATE \
   --service-account=${service_account_email} \
   --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
   --tags=http-server \
   --image=ubuntu-1604-xenial-v20200923 \
   --image-project=ubuntu-os-cloud \
   --boot-disk-size=10GB \
   --boot-disk-type=pd-standard \
   --boot-disk-device-name=${template_name} \
   --no-shielded-secure-boot \
   --shielded-vtpm \
   --shielded-integrity-monitoring \
   --reservation-affinity=any
