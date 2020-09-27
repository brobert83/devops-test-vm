#!/bin/bash

set -x

name=$1

project=workshop-devops-test
service_account_name=ci
zone=us-central1-a

backend_port=3000
frontend_port=80

service_account_email=$(gcloud iam service-accounts list --filter="name:${service_account_name}" --format json | jq --raw-output '.[]| .email')

instance_template=${name}-instance-template
instance_group_name=${name}-mig
service_name=${name}-service
url_map_name=${name}-url-map
address_name=${name}-address
http_proxy_name=${name}-http-proxy
health_check_name=${name}-health-check
frontend_forwarding_rule=${name}-frontend-forwarding-rule

gcloud beta compute \
   --project=${project} instance-templates create ${instance_template} \
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
   --boot-disk-device-name=${instance_template} \
   --no-shielded-secure-boot \
   --shielded-vtpm \
   --shielded-integrity-monitoring \
   --reservation-affinity=any

gcloud compute \
   --project=${project} instance-groups managed create ${instance_group_name} \
   --base-instance-name=${instance_group_name} \
   --template=${instance_template} \
   --size=2 \
   --zone=${zone}

gcloud compute instance-groups unmanaged set-named-ports ${instance_group_name} \
    --named-ports http:${backend_port} \
    --zone ${zone}

gcloud compute health-checks create http ${health_check_name} --port ${backend_port}

gcloud compute backend-services create ${service_name} \
    --global-health-checks \
    --protocol=HTTP \
    --port-name=http \
    --health-checks=${health_check_name} \
    --global

gcloud compute backend-services add-backend ${service_name} \
    --balancing-mode=UTILIZATION \
    --max-utilization=0.8 \
    --capacity-scaler=1 \
    --instance-group=${instance_group_name} \
    --instance-group-zone=${zone} \
    --global

gcloud compute url-maps create ${url_map_name} \
    --default-service ${service_name}

gcloud compute target-http-proxies create ${http_proxy_name} \
    --url-map ${url_map_name}

gcloud compute forwarding-rules create ${frontend_forwarding_rule} \
    --global \
    --target-http-proxy=${http_proxy_name} \
    --ports=${frontend_port}

echo "Frontend IP: $(gcloud compute forwarding-rules describe ${frontend_forwarding_rule} --format=json --global | jq --raw-output '.IPAddress')"
