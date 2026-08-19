# Day 10: Kubernetes Fundamentals

## What I did today
Started Kubernetes from the ground up - focused on understanding *why* it's needed before touching any commands, since this was a completely new area. Covered the core concepts (Pod, Node, Cluster), set up a local cluster with minikube, and deployed my first application, including testing Kubernetes' self-healing behavior firsthand.

## Why Kubernetes (Not Just Docker)
Docker alone can't handle real production scenarios like a sudden traffic spike (e.g. a big sale event). Manually running `docker run` more times, restarting crashed containers, and distributing load across machines isn't practical at scale. Kubernetes solves this by handling:
- **Self-healing** - automatically restarts crashed containers
- **Auto-scaling** - creates more copies of the app based on traffic
- **Load balancing** - distributes traffic across running copies
- **Rolling updates** - deploys new versions without downtime

**Analogy:** Docker is like a single chef; Kubernetes is like the manager running an entire restaurant - deciding how many chefs are needed and replacing one that goes missing.

## Core Concepts
Cluster (the whole system)
└── Node (a server/machine)
└── Pod (wrapper around one or more containers)
└── Container (the actual running app)
- **Pod** - the smallest deployable unit; wraps one or more tightly-coupled containers
- **Node** - a machine (physical or virtual) where Pods actually run
- **Cluster** - the full group of Nodes plus the control plane that manages them

**Important limitation to understand:** a Deployment can create and replace Pods automatically, but it *cannot* create new Nodes or a new Cluster - those come from manual setup or a separate tool (Cluster Autoscaler).

## Setup
```bash
minikube start          # spin up a local single-node cluster
kubectl get nodes        # confirm the node is Ready
```

## Commands Practiced
```bash
kubectl create deployment webapp --image=nginx   # create a deployment
kubectl get pods                                  # list running pods
kubectl get deployments                           # list deployments
kubectl delete pod <podname>                       # delete a specific pod
kubectl delete deployment webapp                    # remove the deployment
```

### Dry-run trick (useful for documentation/planning)
```bash
kubectl create deployment webapp --image=nginx --dry-run=client -o yaml > webapp-deployment.yaml
```
This previews the YAML a deployment *would* use, without actually creating it.

## Self-Healing Test
Deployed nginx, noted the Pod's name, then manually deleted it to simulate a crash:
```bash
kubectl delete pod <podname>
kubectl get pods
```
A new Pod was created automatically within seconds, without any manual intervention - this is the core value proposition of Kubernetes in action.

## Where I got stuck
Took a self-quiz after this session and got tripped up on whether a Deployment can create new Nodes - I do understand now that it can't; new Nodes require either manual setup or a separate autoscaling tool. Also mixed up `kubectl` as `kuberctl` a few times when writing answers - noting this specifically since spelling it wrong out loud in an interview would be an easy, avoidable mistake.

## Files in this folder
- `webapp-deployment.yaml` - dry-run output showing the YAML structure for an nginx deployment

## Interview Question Prep

**Q: What is the difference between Docker and Kubernetes?**
A: Docker builds and runs containers on a single machine. Kubernetes manages containers across multiple machines - handling auto-restart, auto-scaling, and load balancing automatically.

**Q: What is the hierarchy between Pod, Node, and Cluster?**
A: Cluster > Node > Pod > Container. A Cluster is a group of Nodes; each Node is a machine; each Pod wraps one or more containers running on that Node.

**Q: What happens automatically if a Pod crashes?**
A: The Deployment detects it and creates a new Pod automatically - this is Kubernetes' self-healing behavior.

**Q: Can a Deployment create new Nodes?**
A: No. A Deployment only manages Pods. New Nodes are added either manually or through a separate tool like a Cluster Autoscaler.

**Q: What is minikube used for?**
A: Running a small, single-node Kubernetes cluster locally for learning and testing - not intended for production use.
