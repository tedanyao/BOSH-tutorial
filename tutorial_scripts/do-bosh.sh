#!/bin/bash

state="--state=state.json"
if [ -z $1 ]; then
  action="int"
else
  action=$1
fi

# if doing interpolate, then state is invalid option
if [ "$action" == "int" ]; then
  state=""
fi

echo Performing $action
bosh $action \
    $state \
    bosh-deployment/bosh.yml \
    --vars-store=creds.yml \
    -o bosh-deployment/aws/cpi.yml \
    -o set-director-passwd.yml \
    -v director_name=bosh \
    -v internal_cidr=10.0.0.0/24 \
    -v internal_gw=10.0.0.1 \
    -v internal_ip=10.0.0.6 \
    -v access_key_id=AKIAJRMKYXJI6JN5RZ6A \
    -v secret_access_key=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 \
    -v region=us-east-2 \
    -v az=us-east-2b \
    -v default_key_name=bosh \
    -v default_security_groups=[bosh-private-bosh] \
    --var-file private_key=bosh.pem \
    -v subnet_id=subnet-09ee6d2538376c648 \
    --vars-file vars.yml \
