# Exercise 1: Kubernetes Getting Started - Hello Pod

## Objective
Set up a local Kubernetes cluster using Minikube, run the first application (Nginx) as a Pod and expose it to the outside world using a NodePort Service. The same task is done in two ways: imperative (kubectl commands) and declarative (YAML files).

---

## Scenario
A quick commerce company like Zepto runs hundreds of small services (orders, payments, delivery tracking). Each service runs in containers and Kubernetes decides where those containers run, restarts them when they fail and gives them a stable network address. Before deploying a real service, we start with the smallest unit in Kubernetes: a **Pod**.

---

## Concepts Used
| Term | Meaning |
|---|---|
| **Cluster** | Set of machines (nodes) managed by Kubernetes. Minikube gives a single node cluster on the laptop. |
| **Pod** | Smallest deployable unit. Wraps one or more containers that share network and storage. |
| **Service** | Stable endpoint in front of pods. `NodePort` opens a port on the node so we can reach the pod from outside. |
| **kubectl** | Command line client that talks to the Kubernetes API server. |

### What happens internally when we run `kubectl run`
1. `kubectl` sends the request to the **API Server**.
2. The pod object is stored in **etcd**.
3. The **Scheduler** picks a node for the pod.
4. The **kubelet** on that node asks the container runtime to pull `nginx` and start the container.
5. **kube-proxy** sets up the routing rules when the Service is created.

---

## Files
| File | Purpose |
|---|---|
| `nginx-pod.yaml` | Pod definition for the nginx container (label `app: hello-k8s`) |
| `nginx-service.yaml` | NodePort Service that selects the pod by its label |

---

## Steps

### Step 1: Install and start Minikube
```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube start
kubectl get nodes
```
Expected:
```
NAME       STATUS   ROLES           AGE   VERSION
minikube   Ready    control-plane   1m    v1.31.0
```

### Step 2: Create the Pod (imperative)
```bash
kubectl run hello-k8s --image=nginx --port=80
kubectl get pods
```
Wait until `STATUS` shows `Running`.

### Step 3: Expose the Pod as a Service
```bash
kubectl expose pod hello-k8s --type=NodePort --port=80
kubectl get svc
```
Expected:
```
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
hello-k8s    NodePort    10.105.33.20    <none>        80:31234/TCP   5s
```

### Step 4: Access the application
```bash
minikube service hello-k8s --url
curl $(minikube service hello-k8s --url)
```
The response is the default **Welcome to nginx!** HTML page.

### Step 5: Same setup using YAML (declarative)
```bash
kubectl delete svc hello-k8s
kubectl delete pod hello-k8s

kubectl apply -f nginx-pod.yaml
kubectl apply -f nginx-service.yaml
kubectl get pods,svc
```

### Step 6: Inspect the pod
```bash
kubectl describe pod hello-k8s
kubectl logs hello-k8s
```
`describe` shows the node it was scheduled on, the pod IP, the image and the events (Scheduled, Pulling, Pulled, Created, Started).

---

## Observations
- The pod gets an internal IP that changes if the pod is recreated. The Service gives a fixed address.
- The Service finds the pod only through the **label selector** (`app: hello-k8s`).
- The YAML approach is better for real projects because the files can be stored in Git and reapplied.

---

## Cleanup
```bash
kubectl delete -f nginx-service.yaml
kubectl delete -f nginx-pod.yaml
minikube stop
```
