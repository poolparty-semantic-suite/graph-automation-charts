# Graph Automation Helm Chart Changelog

Changelog for the Graphwise Graph Automation umbrella Helm chart.

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
