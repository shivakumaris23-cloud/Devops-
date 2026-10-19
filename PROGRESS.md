# DevOps Lab — Progress Tracker

**Student Name:** Shivakumar  
**USN:** 1BM23IS226  
**Course:** DevOps Lab  
**Repository:** [shivakumaris23-cloud/Devops-](https://github.com/shivakumaris23-cloud/Devops-)  
**Overall Completion:** `10 / 10 Exercises (100%)`  

---

## Progress Overview Dashboard

```
[████████████████████████████████████████] 100% Completed (10/10 Labs)
```

| No. | Lab Module | Key Tech Stack | Deliverables Status | Verification Status |
|:---:|:---|:---|:---:|:---:|
| 01 | [01-Kubernetes-Getting-Started](./01-Kubernetes-Getting-Started/) | Minikube, kubectl, Nginx | Completed | Verified |
| 02 | [02-Minikube-Flask-Deployment](./02-Minikube-Flask-Deployment/) | Docker, Flask, K8s Deployment | Completed | Verified |
| 03 | [03-Flask-Scaling-ReplicaSets](./03-Flask-Scaling-ReplicaSets/) | ReplicaSets, Probes, Scaling | Completed | Verified |
| 04 | [04-Docker-Networking](./04-Docker-Networking/) | Docker Bridge, Redis, MySQL | Completed | Verified |
| 05 | [05-Docker-AppArmor-Security](./05-Docker-AppArmor-Security/) | Linux AppArmor, Container Security | Completed | Verified |
| 06 | [06-Prometheus-Grafana-Monitoring](./06-Prometheus-Grafana-Monitoring/) | Prometheus, Grafana, Metrics Exporter | Completed | Verified |
| 07 | [07-Jenkins-CI-Setup](./07-Jenkins-CI-Setup/) | Jenkins Controller, Docker Volume | Completed | Verified |
| 08 | [08-Jenkins-HelloWorld-Job](./08-Jenkins-HelloWorld-Job/) | Jenkins Freestyle Job, Git Integration | Completed | Verified |
| 09 | [09-Jenkins-MultiStage-Pipeline](./09-Jenkins-MultiStage-Pipeline/) | Declarative Jenkinsfile, PyTest | Completed | Verified |
| 10 | [10-MultiNode-K8s-Cluster](./10-MultiNode-K8s-Cluster/) | Multi-Node Minikube, Microservices | Completed | Verified |

---

## Detailed Lab Breakdown & Checklist

### [Lab 01: Kubernetes Getting Started](./01-Kubernetes-Getting-Started/)
- [x] Started local single-node Minikube cluster (`minikube start --driver=docker`)
- [x] Created imperative and declarative Nginx Hello Pod (`hello-pod.yaml`)
- [x] Configured `NodePort` service to expose pod on high range port (30000-32767)
- [x] Tested endpoint resolution via `minikube service hello-service --url`
- [x] Cleaned up resources with `kubectl delete`

### [Lab 02: Minikube Flask Deployment](./02-Minikube-Flask-Deployment/)
- [x] Built lightweight Flask web application (`app.py`, `requirements.txt`)
- [x] Penned optimized `Dockerfile` using Python alpine/slim base
- [x] Loaded container image directly into Minikube (`minikube image load`)
- [x] Created declarative `Deployment` with replica configuration (`flask-deployment.yaml`)
- [x] Verified zero-downtime rolling updates and pod lifecycle events

### [Lab 03: Flask Scaling with ReplicaSets](./03-Flask-Scaling-ReplicaSets/)
- [x] Created flash sale web application handling burst traffic
- [x] Penned `flashsale-replicaset.yaml` with selector labels and matchLabels
- [x] Configured `livenessProbe` (`/healthz`) and `readinessProbe` (`/ready`)
- [x] Tested manual horizontal scaling (`kubectl scale rs --replicas=5`)
- [x] Verified automated pod healing when terminating individual pods

### [Lab 04: Docker Networking & Inter-Container Communication](./04-Docker-Networking/)
- [x] Created user-defined custom Docker bridge network (`docker network create`)
- [x] Deployed multi-tier stack: Flask application, MySQL database, and Redis cache
- [x] Verified automatic internal DNS resolution using container names
- [x] Tested network isolation between default bridge and custom user bridge
- [x] Validated container ping and HTTP communication across services

### [Lab 05: Docker AppArmor Security](./05-Docker-AppArmor-Security/)
- [x] Drafted custom AppArmor security profile (`my-apparmor-profile`)
- [x] Loaded profile into Linux kernel via `apparmor_parser -r`
- [x] Executed containers with `--security-opt apparmor=my-apparmor-profile`
- [x] Executed automated Python verification scripts (`apply_apparmor.py`, `test_restricted_actions.py`)
- [x] Verified restriction of write permissions and dangerous system calls

### [Lab 06: Prometheus & Grafana Monitoring](./06-Prometheus-Grafana-Monitoring/)
- [x] Created quick-commerce delivery metrics exporter in Python using `prometheus_client`
- [x] Instrumented Counter, Gauge, and Histogram metrics for orders and latencies
- [x] Configured Prometheus scrape jobs in `prometheus.yml`
- [x] Configured alerting threshold rules in `alert_rules.yml`
- [x] Integrated Grafana data source and built visual operational dashboards

### [Lab 07: Jenkins CI Server Setup](./07-Jenkins-CI-Setup/)
- [x] Automated Jenkins container lifecycle using `run-jenkins.sh`
- [x] Attached persistent Docker volume (`jenkins_home`) to preserve state
- [x] Exposed Jenkins web UI (port 8080) and inbound agent port (50000)
- [x] Completed initial setup wizard, admin user creation, and essential plugins installation

### [Lab 08: Jenkins Hello World Freestyle Job](./08-Jenkins-HelloWorld-Job/)
- [x] Created Git-triggered Freestyle job pulling from remote repository
- [x] Authored build execution script (`hello-world.sh`)
- [x] Defined declarative `Jenkinsfile` for scripted/declarative comparison
- [x] Inspected console output logs and build history execution artifacts

### [Lab 09: Jenkins Multi-Stage Declarative Pipeline](./09-Jenkins-MultiStage-Pipeline/)
- [x] Authored Python microservice (`app.py`) with unit test suite (`test_app.py`)
- [x] Penned end-to-end multi-stage `Jenkinsfile`
- [x] Pipeline stages implemented:
  - `Checkout`: Pull source code from SCM
  - `Install Dependencies`: Install python packages
  - `Run Tests`: Execute `unittest` suite and collect reports
  - `Build Image`: Build container image
  - `Deploy (Staging)`: Simulated deployment
- [x] Implemented `post` failure and success notification hooks

### [Lab 10: Multi-Node Kubernetes Microservices Cluster](./10-MultiNode-K8s-Cluster/)
- [x] Provisioned 3-node Minikube cluster (`minikube start --nodes 3 -p multinode-cluster`)
- [x] Developed microservices architecture:
  - `Product Catalog Service` (Flask, REST API)
  - `Shopping Cart Service` (Flask, consumes product catalog)
- [x] Penned K8s manifests for deployments and ClusterIP/NodePort services
- [x] Configured `nodeSelector` / pod scheduling across multiple cluster nodes
- [x] Verified cross-node service discovery, DNS, and traffic routing

---

## Lab Completion Milestones

- **Milestone 1 (Containerization & Networking):** Labs 04, 05 completed. Docker internals, networking topologies, and security confinement understood.
- **Milestone 2 (CI/CD Automation):** Labs 07, 08, 09 completed. Jenkins setup, Freestyle jobs, and Multi-Stage Declarative Pipelines functioning.
- **Milestone 3 (Orchestration & Microservices):** Labs 01, 02, 03, 10 completed. Kubernetes Pods, Deployments, ReplicaSets, Health checks, and Multi-node clusters verified.
- **Milestone 4 (Observability & SRE):** Lab 06 completed. Prometheus metric exposition, alerting rules, and Grafana visualization operational.
