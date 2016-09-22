#!/bin/bash

APP=$1
ENVI=$2
N=$3
SIZE=$4

terraform destroy -var-file="$ENVI.tfvars" -var "server_size=$SIZE" -var "server_count=\"$N\"" -var "env=$ENVI" -var "app=$APP"
