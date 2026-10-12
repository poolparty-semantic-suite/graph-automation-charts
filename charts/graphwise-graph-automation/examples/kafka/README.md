# Kafka Example

To deploy the Graphwise Graph Automation chart, you need a Kafka instance already running.

The YAML files in the folder are a sample configuration for deploying a single replica Kafka cluster using
the [Strimzi Operator](https://strimzi.io/). It creates the following resources:

- A combined node pool with both broker and controller roles
- A single Kafka instance running on the node pool
- Kafka topics for the Graph Automation MorphKGC Kafka worker and Chunker API service and workers
- Kafka users for the MorphKGC and Chunker workers

## Strimzi

You can install the [Strimzi Operator](https://strimzi.io/) by using its official Helm chart:

```shell
kubectl create namespace strimzi-system || true
helm upgrade \
    --install \
    --namespace strimzi-system \
    --create-namespace \
    --set 'watchNamespaces={graphwise-platform, default}' \
    strimzi-operator oci://quay.io/strimzi-helm/strimzi-kafka-operator
```

## Install

To install the Kafka example in the `default` namespace, execute:

```shell
kubectl apply -f kafka.yaml
kubectl apply -f kafka-users.yaml
kubectl apply -f kafka-topics.yaml
```

## Uninstall

You can uninstall the example with:

```shell
kubectl delete -f kafka-topics.yaml
kubectl delete -f kafka-users.yaml
kubectl delete -f kafka.yaml
```

Note that no PVCs are preserved unless you change that in the `KafkaNodePool` resource.
