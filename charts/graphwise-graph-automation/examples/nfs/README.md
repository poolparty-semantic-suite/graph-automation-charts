# NFS Container Storage

To deploy the Graphwise Graph Automation chart, you need a PV in ReadWriteMany mode that can be shared between the
Workflows and the Kafka workers. Depending on your deployment, such storage could be managed by your Kubernetes
provider, or you can deploy one yourself with
the [NFS Ganesha](https://github.com/kubernetes-sigs/nfs-ganesha-server-and-external-provisioner) by the Kubernetes SIG.

## NFS Ganesha

To deploy NFS Ganesha, install the official Helm chart with:

```shell
helm repo add nfs-ganesha \
    https://kubernetes-sigs.github.io/nfs-ganesha-server-and-external-provisioner/ || true
helm repo update nfs-ganesha
helm upgrade --install \
    --namespace storage \
    --create-namespace \
    --values nfs-ganesha.values.yaml \
    --wait --timeout 5m \
    nfs-ganesha nfs-ganesha/nfs-server-provisioner
```

This will deploy a sample NFS server and register a StorageClass `nfs` with auto provisioning.

The default [configurations](nfs-ganesha.values.yaml) are for a simple development storage with 10Gi max of storage
size, so adjust according to your needs. For production, we recommend an enterprise grade NFS provider like AWS NFS or
Azure Storage.

## NFS PVC

To create a NFS backed ReadWriteMany PVC, named `graph-automation-nfs` in the `default` namespace, execute:

```shell
kubectl apply -f nfs-pvc.yaml
```

Then you can then use it in the Graph Automation services like so:

```yaml
extraVolumes:
  - name: data-share
    persistentVolumeClaim:
      claimName: graph-automation-nfs

extraVolumeMounts:
  - name: data-share
    mountPath: /data
```
