#!/usr/bin/env bash

set -e

$(terraform output -state=../00-infrastructure/terraform.tfstate -json node_ips | jq -r 'keys[] as $k | "export IP\($k)=\(.[$k])"')

cat install_rancher.sh | envsubst