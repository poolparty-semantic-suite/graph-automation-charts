# Graphwise Graph Automation Helm Chart

Umbrella Helm chart for installing the Graphwise Graph Automation services in Kubernetes.

## Versioning

> [!IMPORTANT]
> This chart is at an early stage of development, and it might contain future breaking changes until finalized with
> version 1.0.0.

## Prerequisites

- Kubernetes v1.34+
- Helm v3.8+
- Kafka cluster
- PostgreSQL database for Workflows
- PostgreSQL database for Chunker
- NFS storage

For development and testing purposes, you can use [kind](https://kind.sigs.k8s.io/) to create a local Kubernetes
cluster. Check the example [kind.config.yaml](examples/kind/kind.config.yaml).

You can also use the helper script [dev.sh](examples/dev.sh) to configure controllers in your cluster to help with
deploying the chart as well as the necessary CRs:

```shell
./examples/dev.sh --kind --nginx-ingress
```

## Configurations

Please refer to the subcharts for any additional prerequisites, dependencies and required configurations.

1. Graphwise Workflows - See https://github.com/poolparty-semantic-suite/graphwise-workflows-chart regarding the
   following configurations and Secrets:
   1. (Mandatory) Workflows container image pull secret
   2. (Optional) Workflows license secret
   3. (Mandatory) Workflows encryption secret
   4. (Mandatory) Workflows database credentials secret
   5. (Mandatory) Workflows task runners authentication token secret

A minimal configuration overrides for running the Helm chart (given you have used the `dev.sh`):

```yaml
global:
  imagePullSecrets:
    - name: graphwise
workflows:
  license:
    existingSecret: "graphwise-workflows-license"
    tenantId: 1
  configuration:
    encryption:
      existingSecret: "graph-automation-workflows-encryption"
  runners:
    configuration:
      token:
        existingSecret: "graph-automation-runners-token"
```

### Examples

Check under [examples/](examples) for sample configurations for development and testing:

1. [kafka](examples/kafka) - Example Kafka deployment using the Strimzi operator.
2. [kind](examples/kind) - Local Kubernetes cluster using [kind](https://kind.sigs.k8s.io/)
3. [nfs](examples/nfs) - In-cluster NFS provider and dynamic PV provisioner
4. [nginx-ingress](examples/nginx-ingress) - Example configurations for exposing the services via Nginx Ingress.
5. [postgres](examples/postgres) - Example configuration for a deploying a PostgreSQL database using the CNPG Operator.
6. [secrets](examples/secrets) - Example configurations for a local development environment with Secret generation.

## Installation

Once all dependencies are installed and all secrets and configurations are created, you can install the umbrella chart
with:

```shell
helm upgrade --install --dependency-update -f my-values.yaml graph-automation graphwise-graph-automation/graphwise-graph-automation
```

## Uninstall

To remove the Graphwise Graph Automation chart from your Kubernetes cluster, use the following command:

```shell
helm uninstall graph-automation
```

## License

This code is released under the Apache 2.0 License. See [LICENSE](LICENSE) for more details.
