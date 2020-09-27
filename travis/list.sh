#!/bin/bash

gcloud compute --project=workshop-devops-test instance-groups managed list && echo
gcloud compute health-checks list && echo
gcloud compute backend-services list && echo
gcloud compute url-maps list && echo
gcloud compute target-http-proxies list && echo
gcloud compute forwarding-rules list && echo
