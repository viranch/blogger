#!/bin/bash

APP=$1
ENVI=$2
N=$3
SIZE=$4

terraform() {
    subcmd=$1; shift
    docker run --rm -it -v $PWD/site-data/terraform:/data:ro -v $PWD/.state:/state -w /data build/blogger terraform $subcmd -state="/state/terraform.tfstate" "$@"
}

terraform destroy -var-file="$ENVI.tfvars" -var "server_size=$SIZE" -var "server_count=\"$N\"" -var "env=$ENVI" -var "app=$APP"
