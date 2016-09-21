#!/bin/bash

APP=$1
ENVI=$2
N=$3
SIZE=$4

terraform apply -var-file="$ENVI.tfvars" -var "server_size=$SIZE" -var "server_count=\"$N\"" -var "env=$ENVI"

# need to wait before instances come up

ansible-playbook -i terraform.py playbook.yml
