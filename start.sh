#!/bin/bash

APP=$1
ENVI=$2
N=$3
SIZE=$4

LOG_FILE="debug_`date +%FT%T`.log"

echo "Building the builder image..."
docker build -t build/blogger . 2>&1 >> $LOG_FILE || exit 1

terraform() {
    docker run --rm -v $PWD/site-data:/data -w /data build/blogger terraform $@
}
ansible-playbook() {
    docker run --rm -v $PWD/site-data:/data -w /data -e TERRAFORM_STATE_ROOT=/data -v $HOME/.ssh:/root/.ssh:ro build/blogger ansible-playbook $@
}

echo "Spinning up instances..."
terraform apply -var-file="$ENVI.tfvars" -var "server_size=$SIZE" -var "server_count=\"$N\"" -var "env=$ENVI" -var "app=$APP" 2>&1 >> $LOG_FILE || exit 1
ansible-playbook -i terraform.py ./wait_for_instances.yml 2>&1 >> $LOG_FILE || exit 1

echo "Setting up instances..."
ansible-playbook -i terraform.py --ssh-extra-args="-o 'StrictHostKeyChecking=no'" ./playbook.yml 2>&1 >> $LOG_FILE || exit 1

echo "Your blog is ready at http://"`terraform output elb_ip`"/"
