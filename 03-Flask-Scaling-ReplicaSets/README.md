# Exercise 3: Scaling a Flask App on a Single Node using ReplicaSets

## Objective
Run a Flash Sale ordering app as multiple identical pods using a Kubernetes **ReplicaSet**, scale it up during heavy traffic, and see how Kubernetes heals itself when a pod is deleted. Readiness and liveness probes make sure only healthy pods get traffic.

---

## Real Life Use Case: E-commerce Flash Sale
During a flash sale thousands of users press **Buy** at the same second. One pod cannot handle that load. With a ReplicaSet we keep a fixed number of copies of the app running and increase the count when traffic goes up. If any pod crashes, the ReplicaSet controller creates a new one immediately.

---

## Files
| File | Purpose |
|---|---|
| `app.py` | Flask app with `/` (welcome + pod name), `/buy` (simulated checkout) and `/health` (probe endpoint) |
| `Dockerfile` | `python:3.11-slim` image running the app with **gunicorn** on port 5000 |
| `requirements.txt` | flask, gunicorn |
| `flashsale-replicaset.yaml` | ReplicaSet with 3 replicas, readiness + liveness probes on `/health`, and a NodePort Service |

### Endpoints
| Endpoint | Response |
|---|---|
| `GET /` | `{"message": "Welcome to Big Sale!", "pod": "<pod-name>"}` |
| `GET /buy?user=ravi` | order status, random item and `served_by_pod` |
| `GET /health` | `{"status": "healthy"}` used by the probes |

---

## Steps

### Step 1: Clean up and start a single node cluster
```bash
minikube stop
minikube delete
minikube start --nodes=1
kubectl get nodes
```

### Step 2: Build the image inside Minikube
```bash
eval $(minikube docker-env)
docker build -t flashsale:1.0 .
```

### Step 3: Create the ReplicaSet and Service
```bash
kubectl apply -f flashsale-replicaset.yaml
```
```
replicaset.apps/flashsale-rs created
service/flashsale-svc created
```

### Step 4: Verify the pods
```bash
kubectl get rs
kubectl get pods -l app=flashsale
```
```
NAME           DESIRED   CURRENT   READY   AGE
flashsale-rs   3         3         3       40s
```

### Step 5: Send orders and see load balancing
```bash
URL=$(minikube service flashsale-svc --url)
for i in 1 2 3 4 5 6; do curl -s "$URL/buy?user=user$i"; echo; done
```
The `served_by_pod` value changes between requests, so the Service spreads the load across the pods.

### Step 6: Scale up for the sale
```bash
kubectl scale rs flashsale-rs --replicas=5
kubectl get rs
kubectl get pods -o wide
```
`DESIRED` and `READY` both become 5.

### Step 7: Test self healing
```bash
kubectl delete pod <one-pod-name>
kubectl get pods
```
A new pod with a different name is created within seconds, because the current count (4) is less than desired (5).

### Step 8: Scale down after the sale
```bash
kubectl scale rs flashsale-rs --replicas=2
```

---

## Key Observations
- ReplicaSet always keeps **desired = current**.
- Readiness probe keeps a pod out of the Service until `/health` answers.
- Liveness probe restarts a container that stops responding.
- On a single node all pods run on the same machine, so this gives scaling but not node failure protection (that is done in Exercise 10).

---

## Cleanup
```bash
kubectl delete -f flashsale-replicaset.yaml
eval $(minikube docker-env -u)
```
