# Upgrade Guidelines

## 0.5.0

### Document Chunker

The Document Chunker API now requires setting a mandatory `SECRET_TOKEN` environment variable. Make sure to create a
Kubernetes secret containing this token and pass it via `chunkerAPI.security.token.existingSecret`.

You can use the following sample command to create it:

```shell
kubectl create secret generic graph-automation-chunker-api-token \
        --from-literal=SECRET_TOKEN="$(tr -dc A-Za-z0-9 </dev/urandom | head -c 24; echo)"
```
