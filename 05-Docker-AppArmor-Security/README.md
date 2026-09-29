# Exercise 5: Docker Security with AppArmor and Python

## Objective
Harden a Flask container using an **AppArmor** profile so that even if the application is compromised it cannot read sensitive files or run system binaries. Apply and test the profile using the **Docker SDK for Python**.

---

## Scenario
A company runs a public Flask service in Docker. If an attacker finds a bug in the app, they could read `/etc/passwd`, `/etc/shadow` or start a shell. AppArmor is a Linux **Mandatory Access Control** system that limits what a process can do, no matter which user runs it.

---

## Concepts Used
| Term | Meaning |
|---|---|
| **AppArmor** | Linux kernel security module that restricts programs using per-program profiles |
| **Profile** | Set of rules: which files can be read/written, which binaries can run, which capabilities are allowed |
| **enforce mode** | Rules are applied and violations are blocked |
| **complain mode** | Violations are only logged |
| `--security-opt apparmor=<profile>` | Docker flag to run a container under a profile |

---

## Files
| File | Purpose |
|---|---|
| `app.py` | Simple Flask app on port 5000 |
| `Dockerfile` | Builds the `flask-apparmor` image |
| `my-apparmor-profile` | Profile: deny read on `/etc/**`, deny `/var/**`, deny running `/bin` and `/usr/bin` binaries, allow `/app/**` and network |
| `apply_apparmor.py` | Uses the Docker SDK to build the image and start the container with the profile |
| `test_restricted_actions.py` | Starts a container with the profile and tries blocked actions |
| `requirements.txt` | flask, docker |

---

## Steps

### Task 1: Install AppArmor tools
```bash
sudo apt-get update
sudo apt-get install apparmor-utils -y
sudo aa-status
```

### Task 2: Build the Flask image
```bash
docker build -t flask-apparmor .
docker run -d -p 5000:5000 --name flask-plain flask-apparmor
curl http://localhost:5000
docker rm -f flask-plain
```
```
Hello, this is a secure Flask application running inside a Docker container!
```

### Task 3: Load the AppArmor profile
```bash
sudo cp my-apparmor-profile /etc/apparmor.d/my-apparmor-profile
sudo apparmor_parser -r /etc/apparmor.d/my-apparmor-profile
sudo aa-status | grep my-apparmor-profile
```

### Task 4: Run the container with the profile
```bash
docker run --security-opt="apparmor=my-apparmor-profile" -d -p 5000:5000 --name flask-secure flask-apparmor
docker inspect flask-secure --format '{{.AppArmorProfile}}'
curl http://localhost:5000
```
The app still works, and `inspect` shows `my-apparmor-profile`.

### Task 5: Apply the profile from Python
```bash
pip install docker
python3 apply_apparmor.py
```
The script builds the image, starts the container with `security_opt=["apparmor=my-apparmor-profile"]` and prints the container id and status.

### Task 6: Test restricted actions
```bash
python3 test_restricted_actions.py
```
Expected:
```
Container started: f8c2a7f9b9b8

Attempt to read /etc/passwd: Exit Code 1, Output:
Attempt to execute /bin/bash: Exit Code 126, Output:
Container stopped
```

Exit code 1 means the read was denied and 126 means the binary was not allowed to execute.

### Task 7: Check the kernel log for denials
```bash
sudo dmesg | grep -i apparmor | tail
```
Each blocked action appears as `apparmor="DENIED"` with the profile name and file path.

---

## Observations
- The application keeps working normally because `/app/**` and network access are allowed.
- Reading `/etc` files and running shell binaries is blocked even as root inside the container.
- AppArmor adds a layer on top of normal Linux permissions and Docker isolation (defense in depth).

---

## Cleanup
```bash
docker rm -f flask-secure
sudo apparmor_parser -R /etc/apparmor.d/my-apparmor-profile
```
