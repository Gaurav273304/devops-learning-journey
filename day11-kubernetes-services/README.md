# Day 11: Kubernetes Services, Scaling, YAML & ConfigMaps

## What I did today
Covered why Services exist (Pod IPs aren't stable), scaled a deployment up and down to see how --replicas works as an absolute target rather than a relative change, switched from imperative commands to writing an actual deployment YAML file, and used a ConfigMap to inject configuration into a Pod - the Kubernetes equivalent of Docker's -e flag.

## Concepts and Commands Learned

### Services
Pods get a new IP every time they're recreated (after a crash or delete). A Service gives a stable, unchanging address in front of the Pods, so other applications never talk to a Pod directly - they talk to the Service.

kubectl expose deployment webapp --type=NodePort --port=80
kubectl get services

Verified this practically: deleted a Pod, its IP changed, but the Service's CLUSTER-IP stayed exactly the same.

### Scaling
kubectl scale deployment webapp --replicas=4

--replicas=N sets an absolute target, not a relative change. If 8 Pods are running and you set --replicas=4, Kubernetes terminates 4 - it doesn't add 4 more.

### YAML Deployments (Declarative Approach)
Moved from imperative commands (kubectl create deployment) to a declarative YAML file defining the whole desired state:

apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp-yaml
spec:
  replicas: 3
  selector:
    matchLabels:
      app: webapp-yaml
  template:
    metadata:
      labels:
        app: webapp-yaml
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80

kubectl apply -f webapp-deployment.yaml

Useful trick - instead of memorizing YAML syntax, generate it:
kubectl create deployment name --image=nginx --replicas=3 --dry-run=client -o yaml > file.yaml

### ConfigMaps
kubectl create configmap appconfig --from-literal=APP_MODE=production

Referenced it inside a Pod using envFrom + configMapRef, then verified the values were actually injected:
kubectl exec -it configtest-pod -- printenv | grep APP
# APP_MODE=production

## Where I got stuck
Ran into a kubectl: command not found error at the start of the session - turned out kubectl was symlinked to a path provided by Docker Desktop, which wasn't running (I'd shut down my system the night before). Had to learn that Docker Desktop needs to be running in the background for kubectl/Docker commands to work in this WSL setup - a useful lesson in tracing a dependency chain rather than assuming the tool itself was broken.

Also had a moment where I said a deployment was "already running" after applying a YAML file, without actually checking - turned out it hadn't been created yet. Good
cat > README.md << 'EOF'
# Day 11: Kubernetes Services, Scaling, YAML & ConfigMaps

## What I did today
Covered why Services exist (Pod IPs aren't stable), scaled a deployment up and down to see how --replicas works as an absolute target rather than a relative change, switched from imperative commands to writing an actual deployment YAML file, and used a ConfigMap to inject configuration into a Pod - the Kubernetes equivalent of Docker's -e flag.

## Concepts and Commands Learned

### Services
Pods get a new IP every time they're recreated (after a crash or delete). A Service gives a stable, unchanging address in front of the Pods, so other applications never talk to a Pod directly - they talk to the Service.

kubectl expose deployment webapp --type=NodePort --port=80
kubectl get services

Verified this practically: deleted a Pod, its IP changed, but the Service's CLUSTER-IP stayed exactly the same.

### Scaling
kubectl scale deployment webapp --replicas=4

--replicas=N sets an absolute target, not a relative change. If 8 Pods are running and you set --replicas=4, Kubernetes terminates 4 - it doesn't add 4 more.

### YAML Deployments (Declarative Approach)
Moved from imperative commands (kubectl create deployment) to a declarative YAML file defining the whole desired state:

apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp-yaml
spec:
  replicas: 3
  selector:
    matchLabels:
      app: webapp-yaml
  template:
    metadata:
      labels:
        app: webapp-yaml
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80

kubectl apply -f webapp-deployment.yaml

Useful trick - instead of memorizing YAML syntax, generate it:
kubectl create deployment name --image=nginx --replicas=3 --dry-run=client -o yaml > file.yaml

### ConfigMaps
kubectl create configmap appconfig --from-literal=APP_MODE=production

Referenced it inside a Pod using envFrom + configMapRef, then verified the values were actually injected:
kubectl exec -it configtest-pod -- printenv | grep APP
# APP_MODE=production

## Where I got stuck
Ran into a kubectl: command not found error at the start of the session - turned out kubectl was symlinked to a path provided by Docker Desktop, which wasn't running (I'd shut down my system the night before). Had to learn that Docker Desktop needs to be running in the background for kubectl/Docker commands to work in this WSL setup - a useful lesson in tracing a dependency chain rather than assuming the tool itself was broken.

Also had a moment where I said a deployment was "already running" after applying a YAML file, without actually checking - turned out it hadn't been created yet. Good reminder to verify with kubectl get pods instead of assuming a command worked.
## Files in this folder
- webapp-deployment.yaml - declarative deployment definition for nginx
- practice-deployment.yaml - dry-run generated YAML, used to practice the create-verify-apply-confirm workflow
- configmap-pod.yaml - Pod definition that pulls environment variables from a ConfigMap

## Interview Question Prep

Q: Why do you need a Service if a Pod already has an IP?
A: A Pod's IP changes every time it's recreated. A Service provides a stable address in front of the Pods so other parts of the application never lose connectivity due to Pod churn.

Q: What happens if you scale a deployment to fewer replicas than are currently running?
A: Kubernetes terminates the extra Pods to bring the total down to the requested number - --replicas is always an absolute target.

Q: Difference between imperative and declarative approaches in Kubernetes?
A: Imperative uses direct commands to create resources step by step. Declarative defines the full desired state in a YAML file and applies it with one command.

Q: What is a ConfigMap used for?
A: Injecting configuration data into Pods without hardcoding it into the container image - conceptually similar to Docker's -e environment variable flag.
