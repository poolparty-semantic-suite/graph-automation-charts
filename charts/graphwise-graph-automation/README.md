# Graphwise Graph Automation Helm Chart

Umbrella Helm chart for installing the Graphwise Graph Automation services in Kubernetes.

## Versioning

> [!IMPORTANT]
> This chart is at an early stage of development, and it might contain future breaking changes until finalized with
> version 1.0.0.

## Prerequisites

- Kubernetes v1.34+
- Helm v3.8+

For development and testing purposes, you can use [kind](https://kind.sigs.k8s.io/) to create a local Kubernetes
cluster. Check the example [kind.config.yaml](examples/kind/kind.config.yaml).

## Configurations

Please refer to the subcharts for any additional prerequisites, dependencies and required configurations.

1. Graphwise Workflows - See https://github.com/poolparty-semantic-suite/graphwise-workflows-chart regarding the
   following configurations and Secrets:
   1. (Mandatory) Workflows container image pull secret
   2. (Optional) Workflows license secret
   3. (Mandatory) Workflows encryption secret
   4. (Mandatory) Workflows database credentials secret
   5. (Mandatory) Workflows task runners authentication token secret

### Examples

Check under [examples/](examples) for any sample configurations regarding this chart:

1. [dev](examples/dev) - Example configurations for a local development environment with Secret generation.
2. [nginx-ingress](examples/nginx-ingress) - Example configurations for exposing the services via Nginx Ingress.
3. [postgres](examples/postgres) - Example configuration for a deploying a PostgreSQL database using the CNPG Operator.

## Installation

Once all dependencies are installed and all secrets and configurations are created, you can install the umbrella chart
with:

```shell
helm upgrade --install --dependency-update graph-automation graphwise-graph-automation graphwise-graph-automation
```

## Uninstall

To remove the Graphwise Graph Automation chart from your Kubernetes cluster, use the following command:

```shell
helm uninstall graph-automation
```

## License

This code is released under the Apache 2.0 License. See [LICENSE](LICENSE) for more details.
