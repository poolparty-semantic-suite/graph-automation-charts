#!/usr/bin/env bash

#
# This is a helper script to get your Kubernetes cluster ready for deploying the Graph Automation Helm chart.
#

set -o errexit
set -o nounset
set -o pipefail

################################################################################################
# Configuration
################################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

KIND_ENABLED=false
NGINX_ENABLED=false

NAMESPACE="default"
KIND_CLUSTER_NAME="platform"
STRIMZI_NAMESPACE="strimzi-system"
CNPG_NAMESPACE="cnpg-system"
NFS_GANESHA_NAMESPACE="storage"

while [[ $# -gt 0 ]]; do
  case "$1" in
    -k|--kind)
      KIND_ENABLED=true
      shift ;;
    -n|--nginx-ingress)
      NGINX_ENABLED=true
      shift ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

################################################################################################
# KIND
################################################################################################

if [[ "${KIND_ENABLED}" == true ]]; then
  kind create cluster --name ${KIND_CLUSTER_NAME} --config ${SCRIPT_DIR}/kind/kind.config.yaml || true
fi

################################################################################################
# Controllers
################################################################################################

# NGINX Ingress controller

if [[ "${NGINX_ENABLED}" == true ]]; then
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
fi

# Strimzi operator for Kafka clusters

helm upgrade \
    --install \
    --namespace "${STRIMZI_NAMESPACE}" \
    --create-namespace \
    --set 'watchNamespaces={default}' \
    --wait \
    --timeout 5m \
    strimzi-operator \
    oci://quay.io/strimzi-helm/strimzi-kafka-operator

# Cloud Native PostgreSQL (CNPG) Operator

helm repo add cnpg https://cloudnative-pg.github.io/charts || true
helm repo update cnpg
helm upgrade \
    --install \
    --namespace "${CNPG_NAMESPACE}" \
    --create-namespace \
    --wait \
    --timeout 5m \
    cnpg \
    cnpg/cloudnative-pg

# NFS Ganesha for ReadOnlyMany/ReadWriteMany PVs

helm repo add nfs-ganesha \
    https://kubernetes-sigs.github.io/nfs-ganesha-server-and-external-provisioner/ || true
helm repo update nfs-ganesha
helm upgrade \
    --install \
    --namespace "${NFS_GANESHA_NAMESPACE}" \
    --create-namespace \
    --values ${SCRIPT_DIR}/nfs/nfs-ganesha.values.yaml \
    --wait \
    --timeout 5m \
    nfs-ganesha \
    nfs-ganesha/nfs-server-provisioner

################################################################################################
# Resources
################################################################################################

# NFS PVCs

kubectl -n "${NAMESPACE}" apply -f ${SCRIPT_DIR}/nfs/nfs-pvc.yaml

# PostgreSQL

kubectl -n "${NAMESPACE}" apply -f ${SCRIPT_DIR}/postgres/database.yaml
echo "Waiting for cluster/graph-automation-workflows-postgres..."
kubectl -n "${NAMESPACE}" wait cluster/graph-automation-workflows-postgres \
  --for=condition=Ready \
  --timeout=300s
echo "Waiting for cluster/graph-automation-statistics-postgres..."
kubectl -n "${NAMESPACE}" wait cluster/graph-automation-statistics-postgres \
  --for=condition=Ready \
  --timeout=300s

# Kafka

kubectl -n "${NAMESPACE}" apply -f ${SCRIPT_DIR}/kafka/kafka.yaml
kubectl -n "${NAMESPACE}" apply -f ${SCRIPT_DIR}/kafka/kafka-users.yaml
kubectl -n "${NAMESPACE}" apply -f ${SCRIPT_DIR}/kafka/kafka-topics.yaml
echo "Waiting for kafka/graph-automation..."
kubectl -n "${NAMESPACE}" wait kafka/graph-automation \
  --for=condition=Ready \
  --timeout=300s

################################################################################################

echo "Done"
