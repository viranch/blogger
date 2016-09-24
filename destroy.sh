#!/bin/bash

APP=$1
ENVI=$2
N=$3
SIZE=$4

terraform() {
    docker run --rm -it -v $PWD/site-data:/data -w /data build/blogger terraform "$@"
}

terraform destroy -var-file="$ENVI.tfvars" -var "server_size=$SIZE" -var "server_count=\"$N\"" -var "env=$ENVI" -var "app=$APP"
