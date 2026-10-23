# Graph Automation Helm Chart Changelog

Changelog for the Graphwise Graph Automation umbrella Helm chart.

## 0.3.0-RC1

### Breaking

- Updated the PostgreSQL examples to deploy a set of databases in the same PostgreSQL cluster, each with a different role

### Updates

- Updated the default values for all PostgreSQL configurations to use the new examples
- Updated the Kafka example to create a set of Document Ingestion topics and a new user for them
- Updated the Workflows configurations to enable the command execution node
- Updated the `graphwise-workflows` dependency to **0.4.0-RC1**
- Updated the image of the `graphwise-runners` to **1.0.0-RC1**
- Updated the image of the `morphkgc-kafka-worker` to **0.4.0**

## 0.2.0

### New

- Included the MorphKGC Kafka worker as part of the Graph Automation's deployment. It is enabled by default, and you can
  configure it with the `morphkgc` configuration section.
- Included the Document Chunker API and Kafka workers as part of the Graph Automation's deployment.
  They are enabled by default, and you can configure them with the `chunker` configuration sections.
- Added a helper [dev.sh](examples/dev.sh) script that can prepare a local Kubernetes cluster with kind and all
  necessary controllers and CRDs for deploying the Helm chart.

## 0.1.0

Initial release of the Graphwise Automation Helm chart.
