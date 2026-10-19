# DevOps Lab — Faculty Evaluation Preparation

**Student Name:** Shivakumar  
**USN:** 1BM23IS226  
**Course:** DevOps Lab  
**Repository:** [https://github.com/shivakumaris23-cloud/Devops-](https://github.com/shivakumaris23-cloud/Devops-)  

---

## Demonstrated Exercises

| No. | Exercise | Topic | Evidence & Verification |
|:---:|:---|:---|:---|
| 01 | [01-Kubernetes-Getting-Started](./01-Kubernetes-Getting-Started/) | Kubernetes Deployment & Service | Nginx deployment and NodePort Service exposed |
| 02 | [02-Minikube-Flask-Deployment](./02-Minikube-Flask-Deployment/) | Flask on Minikube | Docker image loaded, K8s deployment, health endpoint |
| 03 | [03-Flask-Scaling-ReplicaSets](./03-Flask-Scaling-ReplicaSets/) | ReplicaSets & Scaling | Manual scaling (`replicas=5`) and automatic Pod replacement |
| 04 | [04-Docker-Networking](./04-Docker-Networking/) | Docker Custom Bridge Networking | Flask container communicating with MySQL and Redis via DNS |
| 05 | [05-Docker-AppArmor-Security](./05-Docker-AppArmor-Security/) | Container Security Profiles | Security inspection, AppArmor profile, and Docker Python SDK |
| 06 | [06-Prometheus-Grafana-Monitoring](./06-Prometheus-Grafana-Monitoring/) | Full-Stack Monitoring & Alerting | Prometheus metrics exporter, Grafana dashboard, firing alert |
| 07 | [07-Jenkins-CI-Setup](./07-Jenkins-CI-Setup/) | Jenkins CI Server Setup | Docker container with persistent volume, Successful Freestyle build |
| 08 | [08-Jenkins-HelloWorld-Job](./08-Jenkins-HelloWorld-Job/) | Jenkins & GitHub Integration | Successful repository checkout from Git and automated build |
| 09 | [09-Jenkins-MultiStage-Pipeline](./09-Jenkins-MultiStage-Pipeline/) | Declarative Multi-Stage Pipeline | Five-stage pipeline (Checkout, Install, Test, Build, Deploy) |
| 10 | [10-MultiNode-K8s-Cluster](./10-MultiNode-K8s-Cluster/) | Multi-Node Kubernetes Cluster | Three Ready nodes, five Pods, inter-service HTTP 200 communication |

---

## Important Demonstration Commands

```bash
# Docker Container & Network Status
docker ps -a
docker network ls

# Minikube & Kubernetes Workloads
minikube status
kubectl get nodes -o wide
kubectl get deployments -o wide
kubectl get pods -o wide --show-labels
kubectl get services -o wide
kubectl get replicasets -o wide

# Git History & Commit Verification
git log --oneline -10
git status
```

---

## Demonstration URLs

| Service | URL | Notes |
|:---|:---|:---|
| **Jenkins CI** | [http://localhost:8081](http://localhost:8081) / [http://localhost:8080](http://localhost:8080) | Local Jenkins container must be running |
| **Prometheus** | [http://localhost:9090](http://localhost:9090) | Target scraping active on `/metrics` |
| **Grafana** | [http://localhost:3000](http://localhost:3000) | Operational dashboards configured |

*Note: These URLs require the corresponding local containers to be running.*

---

## Known Notes & Environment Context

- AppArmor enforcement was configured and tested with Docker security options (`--security-opt apparmor=...`).
- Jenkins GitHub integration was validated with automated checkout jobs.
- Exercise 09 implements unit tests (`unittest`), container build, and simulated staging deployment.
- Exercise 10 demonstrates microservice communication (Product Catalog & Shopping Cart) across a 3-node cluster.
- Minikube local image caching was used (`minikube image load`) for zero-external registry dependency.

---

## Faculty Evaluation Preparation Steps

Before demonstrating to faculty:
1. **Start Docker Desktop:** Ensure Docker daemon is active and responsive.
2. **Verify Containers:** Run `docker ps` to verify running containers (Jenkins, Prometheus, Grafana, app containers).
3. **Verify Minikube Cluster:** Run `minikube status` and `kubectl get nodes`.
4. **Inspect Workloads:** Run `kubectl get pods,svc,deploy,rs` across the relevant namespaces.
5. **Demonstrate CI/CD Pipelines:** Open Jenkins UI and show successful build history and stage view.
6. **Demonstrate Observability:** Open Grafana dashboard and Prometheus targets page showing active scrape targets and alerts.
7. **Code & Architecture Walkthrough:** Explain each exercise's problem statement, architecture, manifests, and verification output.

> *Note: This document serves as a structured evaluation checklist and viva preparation guide.*
