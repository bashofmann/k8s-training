#!/usr/bin/env bash

set -e

$(terraform output -state=../00-infrastructure/terraform.tfstate -json node_ips | jq -r 'keys[] as $k | "export IP\($k)=\(.[$k])"')

export KUBECONFIG=$(pwd)/../00-infrastructure/kubeconfig

helm upgrade --install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --set installCRDs=true \
  --version v1.0.4 --create-namespace

kubectl rollout status deployment -n cert-manager cert-manager
kubectl rollout status deployment -n cert-manager cert-manager-webhook

helm upgrade --install rancher rancher-latest/rancher \
  --namespace cattle-system \
  --version 2.5.5 \
  --set hostname=rancher.${IP0}.xip.io --create-namespace

watch kubectl get pods,certificate,ingress -A
