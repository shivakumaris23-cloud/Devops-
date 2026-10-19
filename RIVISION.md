# DevOps Lab — Quick Revision & Reference Guide (RIVISION.md)

**Student Name:** Shivakumar  
**USN:** 1BM23IS226  
**Course:** DevOps Lab  
**Repository:** [shivakumaris23-cloud/Devops-](https://github.com/shivakumaris23-cloud/Devops-)  

---

## 1. Quick Command Cheat Sheet

### Kubernetes & Minikube
```bash
# Cluster Management
minikube start --driver=docker
minikube start --nodes 3 -p multinode-cluster
minikube status
minikube stop && minikube delete

# Image Management with Minikube
minikube image load <image-name>:<tag>
minikube image ls

# Inspecting Resources
kubectl get nodes -o wide
kubectl get pods -o wide --show-labels
kubectl get svc,deploy,rs

# Applying and Deleting Manifests
kubectl apply -f <manifest.yaml>
kubectl delete -f <manifest.yaml>

# Debugging Pods & Workloads
kubectl describe pod <pod-name>
kubectl logs -f <pod-name> [-c <container-name>]
kubectl exec -it <pod-name> -- /bin/sh

# Exposing & Port Forwarding
kubectl expose deployment <name> --port=80 --target-port=5000 --type=NodePort
kubectl port-forward svc/<svc-name> 8080:80
minikube service <svc-name> --url
```

### Docker
```bash
# Image & Container
docker build -t myapp:1.0 .
docker run -d --name app-container -p 5000:5000 myapp:1.0
docker ps -a
docker logs -f app-container
docker exec -it app-container /bin/sh

# Networking
docker network create my-net
docker network inspect my-net
docker run -d --network my-net --name redis-server redis:alpine

# Security & AppArmor
sudo apparmor_parser -r /path/to/profile
docker run --security-opt apparmor=my-profile myapp:1.0
```

### Jenkins
```bash
# Run Jenkins with volume
docker run -d -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home --name jenkins jenkins/jenkins:lts

# Retrieve initial admin password
docker exec -it jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

---

## 2. Lab-by-Lab Core Revision Notes

### Lab 01: Kubernetes Getting Started
- **Key Concepts:**
  - **Pod:** Smallest deployable unit in K8s, encapsulates one or more containers sharing network (localhost) and storage.
  - **NodePort Service:** Exposes the service externally on each Node’s IP at a static port from the default range `30000-32767`.
  - **ClusterIP Service:** Exposes the service internally within the cluster (default service type).
- **Architecture Flow:** Client $\to$ `NodeIP:NodePort` $\to$ Kube-Proxy / Service $\to$ Pod (`targetPort`).

### Lab 02: Minikube Flask Deployment
- **Key Concepts:**
  - **Deployment:** Manages declarative updates for Pods and ReplicaSets; provides self-healing, rolling updates, and rollback capabilities.
  - **Minikube Image Cache:** When using Minikube with Docker driver, local images built on the host must be loaded into Minikube's internal Docker runtime via `minikube image load <img:tag>` or by setting `eval $(minikube docker-env)`.
  - **imagePullPolicy:** Set to `IfNotPresent` or `Never` when using local images without an external registry.

### Lab 03: Flask Scaling with ReplicaSets
- **Key Concepts:**
  - **ReplicaSet:** Ensures a specified number of identical pod replicas are running at any given time using label selectors (`matchLabels`).
  - **Liveness Probe:** Detects if a container has crashed or entered an unrecoverable state; if it fails, Kubelet restarts the container.
  - **Readiness Probe:** Detects if a container is ready to accept incoming network traffic; if it fails, the pod is removed from service endpoints without restarting.
  - **Scaling Command:** `kubectl scale rs <rs-name> --replicas=N`.

### Lab 04: Docker Networking
- **Key Concepts:**
  - **Default Bridge vs User-Defined Bridge:**
    - Default bridge (`bridge`): Does NOT provide automatic DNS resolution between container names; requires manual `--link`.
    - User-defined bridge (`docker network create`): Provides embedded DNS server resolving container names directly into IP addresses.
  - **Network Drivers:** `bridge` (single-host private virtual network), `host` (shares host network stack), `overlay` (multi-host Swarm/Docker cluster networking), `none` (isolated network stack).

### Lab 05: Docker AppArmor Security
- **Key Concepts:**
  - **AppArmor:** Linux Security Module (LSM) that confines programs according to profiles specifying allowed file access, capabilities, and network permissions.
  - **Modes:**
    - *Enforce Mode:* Violations are blocked and logged.
    - *Complain Mode:* Violations are permitted but logged for auditing/profiling.
  - **Loading Profiles:** `apparmor_parser -r /path/to/profile`.
  - **Docker Integration:** `--security-opt apparmor=<profile_name>`.

### Lab 06: Prometheus & Grafana Monitoring
- **Key Concepts:**
  - **Prometheus Metric Types:**
    1. *Counter:* Cumulative metric that only increases or resets to 0 (e.g., total requests, completed orders).
    2. *Gauge:* Metric that can arbitrarily go up and down (e.g., current active users, memory usage, delivery agents available).
    3. *Histogram:* Samples observations and counts them into configurable buckets (e.g., HTTP request duration, delivery latency).
    4. *Summary:* Similar to histogram, calculates configurable quantiles over a sliding time window.
  - **Pull vs Push:** Prometheus pulls (scrapes) metrics over HTTP `/metrics` at regular `scrape_interval`.
  - **Alerting:** Configured in `alert_rules.yml` evaluating PromQL expressions; triggers alerts to Alertmanager when rules breach thresholds for specified `for` duration.

### Lab 07: Jenkins CI Setup
- **Key Concepts:**
  - **Continuous Integration (CI):** Practice of automating the integration of code changes from multiple contributors into a single software project.
  - **Jenkins Controller (Master):** Dispatches build jobs, monitors agents, records build results, serves the web UI.
  - **Jenkins Volume Persistence:** Storing `/var/jenkins_home` on a persistent volume ensures jobs, build history, plugins, and credentials survive container restarts.

### Lab 08: Jenkins Hello World Job
- **Key Concepts:**
  - **Freestyle Job:** Traditional web UI-driven job configuration suited for simple scripts and standalone tasks.
  - **SCM Trigger:** Jenkins polls Git or receives webhooks on commit to trigger automated builds.
  - **Console Output:** Full execution log capturing standard out and error streams from shell execution.

### Lab 09: Jenkins Multi-Stage Pipeline
- **Key Concepts:**
  - **Pipeline as Code:** Storing build definition in a `Jenkinsfile` committed alongside source code in version control.
  - **Declarative Pipeline Structure:**
    ```groovy
    pipeline {
        agent any
        stages {
            stage('Checkout') { steps { checkout scm } }
            stage('Install') { steps { sh 'pip install -r requirements.txt' } }
            stage('Test') { steps { sh 'python -m unittest discover' } }
            stage('Build') { steps { sh 'docker build -t myapp:${BUILD_NUMBER} .' } }
        }
        post {
            always { cleanWs() }
            success { echo 'Pipeline Succeeded!' }
            failure { echo 'Pipeline Failed!' }
        }
    }
    ```

### Lab 10: Multi-Node Kubernetes Cluster
- **Key Concepts:**
  - **Multi-Node Architecture:** Control Plane node(s) managing worker nodes where application pods run.
  - **Node Scheduling:**
    - `nodeSelector`: Simple key-value mapping to assign pods to nodes with matching labels.
    - `nodeAffinity`: Advanced expressive rules (preferred vs required) for pod placement.
  - **Inter-Service Communication:** Microservices communicate inside K8s via `<service-name>.<namespace>.svc.cluster.local` or simply `<service-name>`.

---

## 3. High-Yield Viva Voce Questions & Answers

**Q1: What is the difference between a Pod and a Container?**  
*A:* A container is a single sandboxed process runtime (e.g., Docker). A Pod is a Kubernetes abstraction that wraps one or more tightly coupled containers sharing network namespace (IP & localhost) and storage volumes.

**Q2: What is the difference between Deployment and ReplicaSet?**  
*A:* A ReplicaSet ensures a fixed number of pod replicas are running. A Deployment is a higher-level abstraction that manages ReplicaSets, enabling declarative rolling updates, rollbacks, and pause/resume functions.

**Q3: How does a NodePort service route traffic to a Pod?**  
*A:* When traffic hits `NodeIP:NodePort`, `kube-proxy` rules (via iptables or IPVS) intercept the traffic and forward it to one of the matching Pod IPs on `targetPort`.

**Q4: Explain the difference between Liveness and Readiness Probes.**  
*A:* Liveness probes check if the application is alive; failure results in container restart. Readiness probes check if the application is ready to accept traffic; failure removes the pod from the service endpoint list without killing it.

**Q5: Why is a user-defined bridge preferred over the default bridge in Docker?**  
*A:* User-defined bridges provide automatic DNS resolution by container name, better isolation, and allow dynamic attachment/detachment of containers without restarting them.

**Q6: What is the role of Prometheus and Grafana in an SRE/DevOps stack?**  
*A:* Prometheus collects, stores (time-series TSDB), and evaluates metric alerts by scraping HTTP targets. Grafana queries Prometheus data sources to visualize metrics into dashboards.

**Q7: What is the advantage of Declarative Pipelines over Freestyle Jobs in Jenkins?**  
*A:* Declarative pipelines provide pipeline-as-code versioned in Git, readable syntax, built-in error handling (`post` blocks), multi-branch support, and reproducibility.

**Q8: What does AppArmor enforce in container environments?**  
*A:* AppArmor restricts file capabilities, execution privileges, raw sockets, and administrative Linux capabilities (`CAP_SYS_ADMIN`), mitigating container breakout risks.
