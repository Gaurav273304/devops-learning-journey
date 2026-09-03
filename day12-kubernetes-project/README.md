# Day 12: Kubernetes Persistent Volumes & Combined Project

## What I did today
Went deep into Kubernetes storage - learned the PersistentVolume (PV) and PersistentVolumeClaim (PVC) system, ran into and resolved a real storageClassName mismatch issue, and then combined everything from the past two days (Deployment, Service, ConfigMap, Volume) into a single working project to close out Week 2.

## Concepts and Commands Learned

### PersistentVolumes & PersistentVolumeClaims
Same underlying problem as Docker volumes (Day 9) - if a Pod is deleted, any data inside it is lost unless stored externally. Kubernetes splits this into two pieces:
- PersistentVolume (PV) - represents actual available storage
- PersistentVolumeClaim (PVC) - a request for storage; Pods use the PVC, never the PV directly

# PersistentVolume
apiVersion: v1
kind: PersistentVolume
metadata:
  name: my-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  storageClassName: manual
  hostPath:
    path: /data/mypv

# PersistentVolumeClaim
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: manual
  resources:
    requests:
      storage: 1Gi

Real issue I ran into: left storageClassName out initially, and Kubernetes silently created its own dynamically-provisioned PV instead of binding to the one I'd created manually. Fixed it by explicitly matching storageClassName on both sides - a good lesson in how Kubernetes fills in gaps with its own defaults if you're not explicit.

### Mounting a Volume in a Pod
spec:
  containers:
  - name: nginx
    image: nginx
    volumeMounts:
    - mountPath: /data
      name: my-storage
  volumes:
  - name: my-storage
    persistentVolumeClaim:
      claimName: my-pvc

volumes (Pod-level) defines the storage source; volumeMounts (container-level) attaches it to a specific path inside the container.

Verified persistence: wrote a file inside the Pod, deleted the Pod, and confirmed the same data was still there when a new Pod came up using the same PVC.

## The Combined Project
Brought together everything from Week 2 into one Deployment:
- ConfigMap for app configuration (APP_MODE, APP_NAME)
- PersistentVolume/PVC for storage
- Deployment running 3 replicas, referencing both the volume and the ConfigMap
- Service exposing it with a stable address

Verified all four pieces working together: environment variables were present inside the Pod, and data written to the mounted volume survived a Pod deletion and recreation.

## Where I got stuck
Did a self-quiz after this session and two gaps showed up clearly: I couldn't recall the nested YAML structure for specifying PVC storage size (spec.resources.requests.storage, not just spec.storage), and I drew a blank on the kubectl exec -it <pod> -- bash command despite having used it minutes earlier in the same session. Both point to the same thing - I understand the concepts well when reasoning through them, but exact command/YAML syntax isn't sticking without actively recalling it myself (rather than just following along).

## Files in this folder
- pv.yaml / pvc.yaml - PersistentVolume and PersistentVolumeClaim definitions
- volumepod.yaml - test Pod mounting the PVC, used to verify data persistence
- project-deployment.yaml - the combined deployment referencing both the ConfigMap and the PVC

## Week 2 Summary
Covered Docker fundamentals (containers, Dockerfiles, custom images), Docker volumes/networking/Compose, and Kubernetes (Pods, Nodes, Services, scaling, YAML deployments, ConfigMaps, and Persistent Volumes) - ending with a working multi-concept project and a GitHub repo showing daily, documented progress.

## Interview Question Prep

Q: What is the difference between a PV and a PVC?
A: A PV represents actual available storage. A PVC is a request for storage - Pods consume storage through a PVC, never directly through the PV.

Q: Why use a PVC instead of defining storage directly in a Pod?
A: It decouples the Pod from the storage implementation. The Pod only knows it has a claim for a certain amount of storage - not where that storage actually comes from (local disk, cloud storage, etc.).

Q: What's the difference between volumes and volumeMounts?
A: volumes (Pod-level) defines where the storage comes from. volumeMounts (container-level) attaches that volume to a specific path inside a container.

Q: What happens if storageClassName doesn't match between a PV and a PVC?
A: Kubernetes will dynamically provision a new PV instead of binding to the manually created one - a mismatch is silently worked around rather than throwing an error.
