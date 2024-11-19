#!/usr/bin/env bash

set -euo pipefail

tofu init
tofu apply --auto-approve

export KUBECONFIG=`pwd`/config/cluster.yaml

helm repo add nvidia https://helm.ngc.nvidia.com/nvidia \
    && helm repo update

helm install gpu-operator -n gpu-operator \
  --create-namespace nvidia/gpu-operator \
  -f helm/values.yaml

echo ACCESS DETAILS:
echo
echo \*\*\* AI CLUSTER
echo export KUBECONFIG=`pwd`/config/cluster.yaml