#!/bin/bash

APP=$1
ENVI=$2
N=$3
SIZE=$4

LOG_FILE="./.state/debug_`date +%FT%T`.log"

echo "Building the builder image..."
for app in terraform ansible; do
    docker build -t $app -f Dockerfile.$app . || exit 1
done 2>&1 >> $LOG_FILE

terraform() {
    subcmd=$1; shift
    docker run --rm -v $PWD/site-data/terraform:/data:ro -v $PWD/.state:/state -w /data terraform $subcmd -state="/state/terraform.tfstate" "$@"
}
ansible-playbook() {
    docker run --rm -v $PWD/site-data/ansible:/data:ro -v $PWD/.state:/state -w /data -e TERRAFORM_STATE_ROOT=/state -v $HOME/.ssh:/root/.ssh:ro ansible "$@"
}

echo "Spinning up instances..."
(
terraform apply -var-file="$ENVI.tfvars" -var "server_size=$SIZE" -var "server_count=\"$N\"" -var "env=$ENVI" -var "app=$APP" || exit 1
ansible-playbook -i terraform.py ./wait_for_instances.yml || exit 1
) 2>&1 >> $LOG_FILE

echo "Setting up instances..."
ansible-playbook -i terraform.py --ssh-extra-args="-o 'StrictHostKeyChecking=no'" ./playbook.yml 2>&1 >> $LOG_FILE || exit 1

echo "Your blog is ready at http://"`terraform output elb_ip`"/"
