# Exercise 7: Introduction to Continuous Integration and Jenkins Installation

## Objective
Understand what Continuous Integration (CI) is, why teams use it, compare common CI tools and install **Jenkins** using Docker so it is ready for the next exercises.

---

## What is Continuous Integration?
Continuous Integration is the practice of merging every developer's code into a shared repository many times a day. Each merge automatically triggers a **build** and **tests**. If something breaks, the team knows within minutes and fixes it while the change is still fresh.

### Key Features
- Single shared repository (Git)
- Automated build on every commit
- Automated tests
- Fast feedback to developers
- Build results visible to the whole team

### Benefits
| Benefit | Explanation |
|---|---|
| Early bug detection | Problems are caught right after the commit that caused them |
| Less integration pain | Small frequent merges instead of one big merge at the end |
| Faster releases | Main branch is always in a buildable state |
| Better quality | Tests run every time, not only before a release |

### How CI Works
```
Developer -> git push -> CI server detects change -> checkout code
          -> build -> run tests -> report result (pass/fail) -> notify team
```

---

## CI Tools Comparison
| Tool | Type | Notes |
|---|---|---|
| **Jenkins** | Self-hosted, open source | Huge plugin ecosystem, pipeline as code (Jenkinsfile) |
| GitLab CI/CD | Built into GitLab | `.gitlab-ci.yml`, runners |
| GitHub Actions | Built into GitHub | YAML workflows, marketplace actions |
| CircleCI | Cloud | Fast, Docker based |
| Travis CI | Cloud | Popular for open source |
| Bamboo | Atlassian | Integrates with Jira and Bitbucket |
| TeamCity | JetBrains | Strong build chains |
| Azure Pipelines | Microsoft | Works with any repo, Windows/Linux/macOS agents |
| Spinnaker | CD focused | Multi-cloud deployments |

---

## Files
| File | Purpose |
|---|---|
| `run-jenkins.sh` | Starts the Jenkins LTS container and prints the initial admin password |

---

## Jenkins Installation (Docker)

### Step 1: Run Jenkins
```bash
docker run -d --name jenkins -p 8080:8080 -p 50000:50000 jenkins/jenkins:lts
docker ps
```
```
CONTAINER ID   IMAGE                 PORTS                                              NAMES
78a4587c55da   jenkins/jenkins:lts   0.0.0.0:8080->8080/tcp, 0.0.0.0:50000->50000/tcp   jenkins
```
Port **8080** is the web UI, port **50000** is for agents.

### Step 2: Get the initial admin password
```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```
or use `bash run-jenkins.sh` which does both steps.

### Step 3: Complete the setup wizard
1. Open `http://localhost:8080`
2. Paste the initial admin password
3. Choose **Install suggested plugins**
4. Create the first admin user
5. Keep the Jenkins URL as `http://localhost:8080/`

### Step 4: Verify
The Jenkins dashboard opens with **New Item**, **Build History** and **Manage Jenkins** options.

---

## Observations
- Running Jenkins in Docker avoids installing Java and Jenkins on the host.
- Jenkins data lives in `/var/jenkins_home` inside the container; use a volume (`-v jenkins_home:/var/jenkins_home`) to keep it after the container is removed.

---

## Cleanup
```bash
docker stop jenkins
docker rm jenkins
```
