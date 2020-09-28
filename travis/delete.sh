#!/bin/bash

name=$1

zone=us-central1-a
project=buildit-devops-test

instance_template=${name}-instance-template
instance_group_name=${name}-mig
service_name=${name}-service
url_map_name=${name}-url-map
address_name=${name}-address
http_proxy_name=${name}-http-proxy
health_check_name=${name}-health-check
frontend_forwarding_rule=${name}-frontend-forwarding-rule
firewall_lb_allow_name=${name}-fw-allow-health-check-and-proxy

gcloud compute forwarding-rules delete ${frontend_forwarding_rule} --global -q
gcloud compute target-http-proxies delete ${http_proxy_name} -q
gcloud compute url-maps delete ${url_map_name} -q
gcloud compute backend-services delete ${service_name} --global -q
gcloud compute --project=${project} instance-groups managed delete ${instance_group_name} --zone=${zone} -q
gcloud beta compute --project=${project} instance-templates delete ${instance_template} -q
gcloud compute health-checks delete ${health_check_name} -q
gcloud compute addresses delete ${address_name} --global -q
gcloud compute firewall-rules delete ${firewall_lb_allow_name} -q

