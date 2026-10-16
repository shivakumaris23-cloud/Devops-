# Exercise 10: Multi-Node Kubernetes Cluster with Multiple Applications

## Objective
Create a **3 node** Minikube cluster and deploy two microservices of an online store (Product Catalog and Shopping Cart), each with 2 replicas. Use **Pod Anti-Affinity** so replicas of the same app are placed on different nodes, giving high availability if one node fails.

---

## Storyboard
An online store is split into small services. The Product Catalog lists items and the Shopping Cart stores what a customer adds. If both copies of a service run on the same node and that node goes down, the service is gone. Spreading replicas across nodes avoids this.

```
            devops-multinode cluster
 +------------------+------------------+------------------+
 |  node 1          |  node 2          |  node 3          |
 |  product-catalog |  product-catalog |                  |
 |  shopping-cart   |                  |  shopping-cart   |
 +------------------+------------------+------------------+
      product-catalog-service (NodePort)   shopping-cart-service (NodePort)
```

---

## Applications
| App | Endpoint | Description |
|---|---|---|
| Product Catalog | `GET /products` | returns list of products (Laptop, Phone, Headphones) |
| Shopping Cart | `GET /cart` | returns cart items |
| Shopping Cart | `POST /cart` | adds an item (JSON) and returns the cart |

Both apps listen on port 80.

---

## Files
| File | Purpose |
|---|---|
| `product_catalog.py` | Product Catalog Flask service |
| `shopping_cart.py` | Shopping Cart Flask service |
| `Dockerfile.product` | Image for Product Catalog |
| `Dockerfile.shopping` | Image for Shopping Cart |
| `product_catalog_deployment.yaml` | 2 replicas, `podAntiAffinity` on `kubernetes.io/hostname`, `imagePullPolicy: Never` |
| `shopping_cart_deployment.yaml` | Same for Shopping Cart |
| `product_catalog_service.yaml` | NodePort service on port 80 |
| `shopping_cart_service.yaml` | NodePort service on port 80 |

---

## Steps

### Step 0: Clean up old clusters
```bash
minikube stop
minikube delete
```

### Step 1: Start a 3 node cluster
```bash
minikube start --nodes 3 -p devops-multinode --force
minikube -p devops-multinode addons enable registry
kubectl get nodes
```
```
NAME                   STATUS   ROLES           AGE   VERSION
devops-multinode       Ready    control-plane   2m    v1.31.0
devops-multinode-m02   Ready    <none>          1m    v1.31.0
devops-multinode-m03   Ready    <none>          1m    v1.31.0
```

### Step 2: Build the images
```bash
docker build -t product-catalog:latest -f Dockerfile.product .
docker build -t shopping-cart:latest -f Dockerfile.shopping .
docker images | grep -E "product-catalog|shopping-cart"
```

### Step 3: Load the images into all nodes
```bash
minikube -p devops-multinode image load product-catalog:latest
minikube -p devops-multinode image load shopping-cart:latest
minikube -p devops-multinode ssh -- docker images
```

### Step 4: Deploy the applications
```bash
kubectl apply -f product_catalog_deployment.yaml
kubectl apply -f shopping_cart_deployment.yaml
kubectl apply -f product_catalog_service.yaml
kubectl apply -f shopping_cart_service.yaml
```

### Step 5: Check pod placement
```bash
kubectl get pods -o wide
```
```
NAME                               READY   STATUS    NODE
product-catalog-6d9f7c8b5-4kx2p    1/1     Running   devops-multinode
product-catalog-6d9f7c8b5-r8m7z    1/1     Running   devops-multinode-m02
shopping-cart-5f8b9d6c7-h2lqw      1/1     Running   devops-multinode-m03
shopping-cart-5f8b9d6c7-p9vtn      1/1     Running   devops-multinode
```
The two replicas of each app are on **different nodes** because of the anti-affinity rule.

### Step 6: Access the services
Run each in a new terminal (the command keeps a tunnel open):
```bash
minikube -p devops-multinode service product-catalog-service --url
minikube -p devops-multinode service shopping-cart-service --url
```

### Step 7: Test the APIs
```bash
curl <product-url>/products
```
```json
[{"id": 1, "name": "Laptop", "price": 1200}, {"id": 2, "name": "Phone", "price": 800}, {"id": 3, "name": "Headphones", "price": 150}]
```
```bash
curl <cart-url>/cart
# []

curl -X POST <cart-url>/cart -H "Content-Type: application/json" -d '{"id": 1, "name": "Laptop", "quantity": 1}'
# [{"id": 1, "name": "Laptop", "quantity": 1}]
```

### Step 8: Simulate a node failure
```bash
kubectl drain devops-multinode-m02 --ignore-daemonsets --delete-emptydir-data
kubectl get pods -o wide
```
The evicted replica cannot be placed on a node that already has a copy, so it stays `Pending` until a free node is available. The other replica keeps serving traffic. Bring the node back with:
```bash
kubectl uncordon devops-multinode-m02
```

---

## Observations
- `requiredDuringSchedulingIgnoredDuringExecution` is a hard rule: replicas of the same app never share a node.
- The cart is stored in memory, so each replica has its own cart (a real system would use a database or Redis).
- Images must be loaded into every node because `imagePullPolicy: Never` is used.

---

## Cleanup
```bash
kubectl delete -f .
minikube delete -p devops-multinode
```
