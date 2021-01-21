# Rancher Kubernetes Training

## Necessary tools

* terraform
* envsubst
* k3sup
* kubectl
* helm

## Setup infrastructure

```
cd 00-infrastructure
terraform apply
./print_install_commands.sh
```

Run k3sup commands and export Kubeconfig

```
cd ..
```

## Create first deployment

```
kubectl apply -f 01-deployment/
```

Follow rollout

```
kubectl rollout status deployment rancher-demo
kubectl get pods --all-namespaces -o wide
```

* Describe a pod
* Show logs of a pod

Access application
```
kubectl run curl --image=radial/busyboxplus:curl -i --tty --rm
curl http://POD_IP
```

## Create service

```
kubectl apply -f 02-service/
kubectl get services
kubectl describe service rancher-demo
```

Access application
```
kubectl run curl --image=radial/busyboxplus:curl -i --tty --rm
curl http://rancher-demo
```

## Create ingress

Update IP in ingress.yaml (`kubectl get nodes -o wide`)

```
kubectl apply -f 03-ingress/
kubectl get ingress
```

Go to ingress

## Update deployment

```
kubectl apply -f 04-deployment-update/
watch kubectl get pods
```

## Configure resources and health checks

Show current resources

```
kubectl top pods
```

```
kubectl apply -f 05-deployment-advanced-features/
watch kubectl get pods
```

Describe not ready pod

Fix health check

```
kubectl apply -f 05-deployment-advanced-features/
watch kubectl get pods
```

## Add configmap

```
kubectl apply -f 06-configmap/
watch kubectl get pods
```

## Install Rancher

```
helm repo add jetstack https://charts.jetstack.io
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
```

```
cd 07-rancher
./print_install_commands.sh
```

Install Rancher

```
cd ..
```

## Use Rancher

* Creating additional clusters
* Authentication & RBAC
* Cluster Explorer
* Apps & Marketplace

## Monitoring & Logging

Install Rancher Monitoring

Optional:

Install Rancher Logging
Install Loki

```
helm repo add loki https://grafana.github.io/loki/charts
helm upgrade --install loki loki/loki --namespace loki --create-namespace
```

Configure logging flow and grafana datasource

```
kubectl apply -f 08-monitoring-logging
kubectl rollout restart deployment -n cattle-monitoring-system rancher-monitoring-grafana
```

Go to grafana, login with admin/prom-operator, go to explorer, show logs `{namespace="default"}`.

## Cleanup

```
cd 00-infrastructure
terraform destroy
cd ..
```