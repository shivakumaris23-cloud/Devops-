# Exercise 6: Real-Time Operations Monitoring and Alerting (Quick Commerce)

## Objective
Monitor a quick commerce delivery system in real time. A Python app exposes delivery metrics, **Prometheus** scrapes them every few seconds and evaluates alert rules, and **Grafana** shows them on a live dashboard. Jenkins is used to automate the setup.

---

## Scenario
A 10-minute grocery delivery company needs to know immediately when orders start piling up. If pending deliveries go above a limit or the average delivery time becomes too high, the operations team must get an alert before customers start complaining.

```
delivery_metrics.py (:8000/metrics)
          |
          |  scrape every 15s
          v
   Prometheus (:9090)  -- alert_rules.yml --> Alerts page
          |
          v
    Grafana (:3000) dashboard
```

---

## Metrics Exposed
| Metric | Type | Meaning |
|---|---|---|
| `total_deliveries` | Gauge | total orders in the current cycle |
| `pending_deliveries` | Gauge | orders not yet picked up |
| `on_the_way_deliveries` | Gauge | orders out for delivery |
| `average_delivery_time` | Summary | delivery time in seconds (`_sum` and `_count`) |

## Alert Rules
| Alert | Condition | Severity |
|---|---|---|
| `HighPendingDeliveries` | `pending_deliveries > 10` for 15s | warning |
| `HighAverageDeliveryTime` | `average_delivery_time_sum / average_delivery_time_count > 30` | critical |

---

## Files
| File | Purpose |
|---|---|
| `delivery_metrics.py` | Simulates delivery data and serves metrics on port 8000 |
| `prometheus.yml` | Scrape jobs for Prometheus itself and the delivery service (`172.17.0.1:8000`) |
| `alert_rules.yml` | Alert rules listed above |
| `Dockerfile` | Container image for the metrics app |
| `Jenkinsfile` | Pipeline: pre-check Docker, setup workspace, build image, run app, run Prometheus and Grafana |
| `requirements.txt` | prometheus-client |

---

## Steps

### Step 1: Run the metrics app
```bash
pip3 install prometheus-client
python3 delivery_metrics.py
```
```
[INFO] Sleeping for 1 seconds...
[DEBUG] Total deliveries: 69
[DEBUG] Pending deliveries: 20
[DEBUG] On-the-way deliveries: 17
[DEBUG] Average delivery time: 28.26 seconds
```

### Step 2: Check the metrics endpoint
```bash
curl http://localhost:8000/metrics | grep deliveries
```
```
# TYPE pending_deliveries gauge
pending_deliveries 20.0
on_the_way_deliveries 17.0
total_deliveries 69.0
```

### Step 3: Find the Docker host IP
```bash
ip addr show docker0
```
The `inet` address (usually `172.17.0.1`) is used in `prometheus.yml` so the Prometheus container can reach the app running on the host.

### Step 4: Start Prometheus
```bash
docker run -d --name prometheus --network=host \
  -v ./prometheus.yml:/etc/prometheus/prometheus.yml \
  -v ./alert_rules.yml:/etc/prometheus/alert_rules.yml \
  prom/prometheus
docker ps | grep prom
```
Open `http://localhost:9090` → **Status → Targets**. Both `prometheus` and `delivery_service` should be **UP**.

### Step 5: Check alerts
Open **Alerts** in Prometheus. `HighPendingDeliveries` goes from *Pending* to *Firing* after 15 seconds when pending is above 10.

### Step 6: Start Grafana
```bash
docker run -d --name grafana -p 3000:3000 grafana/grafana
```
1. Open `http://localhost:3000`, login `admin / admin` (skip password change).
2. **Connections → Data sources → Add → Prometheus**, URL `http://172.17.0.1:9090`, **Save & test**.
3. **Dashboards → New → Add visualization**, add panels for `pending_deliveries`, `on_the_way_deliveries`, `total_deliveries` and `rate(average_delivery_time_sum[1m]) / rate(average_delivery_time_count[1m])`.
4. Set refresh to 5s to see live changes.

### Step 7: Automate with Jenkins
```bash
docker run -d --name jenkins -p 8080:8080 -p 50000:50000 jenkins/jenkins:lts
```
Create a Pipeline job that uses this `Jenkinsfile` (Pipeline script from SCM) and run **Build Now**.

### Step 8: Trigger a critical situation
Change the pending range in `delivery_metrics.py`:
```python
pending = random.randint(50, 100)
```
Restart the app and watch the alert fire and the Grafana panel jump.

---

## Observations
- Prometheus pulls (scrapes) metrics. The app only exposes them.
- Alert rules are evaluated inside Prometheus; Grafana only visualizes.
- `localhost` inside a container means the container itself, so the host IP `172.17.0.1` is used.

---

## Cleanup
```bash
docker rm -f prometheus grafana jenkins
```
