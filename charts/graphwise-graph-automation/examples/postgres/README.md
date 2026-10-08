# Postgres Database Example

To deploy the Graphwise Graph Automation chart, you need a PostgreSQL database already running.
The [database.yaml](database.yaml) is a sample configuration for deploying a single replica PostgreSQL database using
the [CNPG Operator](https://cloudnative-pg.io/).

## CNPG

You can install the [CNPG Operator](https://cloudnative-pg.io/) with:

```shell
helm repo add cnpg https://cloudnative-pg.github.io/charts || true
helm repo update cnpg
helm upgrade \
  --install \
  --namespace "${CNPG_NAMESPACE}" \
  --create-namespace \
  cnpg \
  cnpg/cloudnative-pg
```

## Install

To install the database in the `default` namespace, execute:

```shell
kubectl apply -f database.yaml
```

After the database is ready, you can configure the chart to use it:

```yaml
workflows:
  configuration:
    postgresdb:
      host: graph-automation-workflows-postgres-rw
      database: graph-automation
      credentials:
        existingSecret: graph-automation-workflows-postgres-app
        usernameKey: username
        passwordKey: password
```

## Uninstall

You can uninstall the database with:

```shell
kubectl delete -f database.yaml
```
