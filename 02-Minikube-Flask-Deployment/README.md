# Exercise 2: Deploy a Flask App on Minikube using kubectl and YAML

## Objective
Containerize a simple Python Flask application, build the image directly inside Minikube's Docker daemon (no registry needed) and deploy it using a Kubernetes **Deployment** and **NodePort Service** written in YAML.

---

## Architecture
```
 curl / browser
      |
 minikube service url  (NodePort)
      |
 flask-app-service  ->  flask-app pod (container port 15000)
                         image: flask-app:latest (built inside minikube)
```

---

## Files
| File | Purpose |
|---|---|
| `app.py` | Flask app with one route `/` that returns a greeting, listens on port 15000 |
| `Dockerfile` | Builds the image from `python:3.8-slim` and installs Flask |
| `requirements.txt` | Python dependency list |
| `flask-deployment.yaml` | Deployment (1 replica, `imagePullPolicy: Never`) + NodePort Service |

**Why `imagePullPolicy: Never`?** The image is built locally inside Minikube. Without this, Kubernetes tries to pull `flask-app:latest` from Docker Hub and the pod fails with `ErrImagePull`.

---

## Minikube Commands Used
| Command | Use |
|---|---|
| `minikube start / stop / delete` | manage the cluster |
| `minikube status` | check cluster health |
| `minikube docker-env` | point local docker CLI to minikube's docker |
| `minikube service <name> --url` | get the URL of a NodePort service |
| `minikube dashboard` | open the web dashboard |

---

## Steps

### Step 1: Start Minikube
```bash
minikube start
minikube status
```

### Step 2: Point Docker to Minikube and build the image
```bash
minikube docker-env
eval $(minikube docker-env)
docker build -t flask-app .
docker images | grep flask-app
```

### Step 3: Deploy the application
```bash
kubectl apply -f flask-deployment.yaml
```
Output:
```
deployment.apps/flask-app created
service/flask-app-service created
```

### Step 4: Verify the Deployment and Pods
```bash
kubectl get deployments
kubectl get pods -l app=flask-app
```
```
NAME        READY   UP-TO-DATE   AVAILABLE   AGE
flask-app   1/1     1            1           20s
```

### Step 5: Debug if needed
```bash
kubectl describe deployment flask-app
kubectl logs <pod-name>
```
Logs should show:
```
 * Serving Flask app 'app'
 * Running on all addresses (0.0.0.0)
 * Running on http://127.0.0.1:15000
```

### Step 6: Access the service
`curl http://127.0.0.1:15000` from the host does not work because the pod is inside the cluster network. Use the service URL instead:
```bash
kubectl get services
minikube service flask-app-service --url
curl http://127.0.0.1:<port>
```
Output:
```
Hello from Flask on Kubernetes!
```

---

## Observations
- Building inside Minikube's Docker avoids pushing the image to a registry.
- The Deployment recreates the pod automatically if it is deleted (`kubectl delete pod <name>`).
- The Service links to the pod using the label `app: flask-app`.

---

## Cleanup
```bash
kubectl delete -f flask-deployment.yaml
eval $(minikube docker-env -u)
```
