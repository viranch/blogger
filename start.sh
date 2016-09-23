#!/bin/bash

APP=$1
ENVI=$2
N=$3
SIZE=$4

LOG_FILE="debug_`date +%FT%T`.log"

echo "Spinning up instances..."
terraform apply -var-file="$ENVI.tfvars" -var "server_size=$SIZE" -var "server_count=\"$N\"" -var "env=$ENVI" -var "app=$APP" 2>&1 > $LOG_FILE || exit 1
ansible-playbook -i terraform.py ./wait_for_instances.yml 2>&1 > $LOG_FILE || exit 1

echo "Setting up instances..."
ansible-playbook -i terraform.py --ssh-extra-args="-o 'StrictHostKeyChecking=no'" ./playbook.yml 2>&1 > $LOG_FILE || exit 1

echo "Your blog is ready at http://"`terraform output elb_ip`"/"
