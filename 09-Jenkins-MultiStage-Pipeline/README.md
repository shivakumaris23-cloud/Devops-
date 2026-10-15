# Exercise 9: Jenkins Multi-Stage Pipeline for a Python Application

## Objective
Build a declarative **Jenkins Pipeline** (Jenkinsfile) with multiple stages that installs dependencies, runs unit tests, deploys and starts a Flask application, and then tests the running app. The pipeline is stored in Git (Pipeline as Code).

---

## Scenario
A team wants every push to automatically check that the app still works. If a test fails, the pipeline stops and the broken code is never deployed.

```
Build -> Test -> Deploy -> Run Application -> Test Application
```

---

## Files
| File | Purpose |
|---|---|
| `app.py` | Flask app, `/` returns `Hello, Jenkins Multi-Stage Pipeline!` |
| `test_app.py` | `unittest` test that calls `/` and checks status 200 and the response text |
| `requirements.txt` | flask==2.1.2 |
| `Jenkinsfile` | 5-stage declarative pipeline with `post` success/failure messages |

## Pipeline Stages
| Stage | What it does |
|---|---|
| **Build** | Prepares the environment and dependencies |
| **Test** | `python3 -m unittest discover -s .` |
| **Deploy** | Copies `app.py` into `${WORKSPACE}/python-app-deploy` |
| **Run Application** | Starts the app in the background with `nohup`, saves the PID |
| **Test Application** | Runs `test_app.py` again against the deployed code |

---

## Steps

### Step 1: Test locally
```bash
pip install -r requirements.txt
python3 -m unittest discover -s .
```
```
Hello, Jenkins Multi-Stage Pipeline!
.
----------------------------------------------------------------------
Ran 1 test in 0.012s

OK
```

### Step 2: Push the code to GitHub
```bash
git init
git add .
git commit -m "add flask app, tests and Jenkinsfile"
git remote add origin https://github.com/<your-GitHub-username>/devops-sample-code.git
git push -u origin main
```

### Step 3: Create the pipeline job
1. Jenkins → **New Item** → `Python-MultiStage-Pipeline` → **Pipeline** → **OK**
2. **Pipeline → Definition:** *Pipeline script from SCM*
3. **SCM:** Git, repository URL, branch `*/main`, script path `Jenkinsfile`
4. **Save**

### Step 4: Fix missing Python in the Jenkins container
The first run fails with `python3: not found` because the Jenkins image has no Python.
```bash
docker ps -a
docker exec -it -u root <container-id> bash
apt-get update
apt-get install -y python3 python3-pip python3-flask
exit
```

### Step 5: Run the pipeline
Click **Build Now**. The **Stage View** shows each stage with its time. Console output ends with:
```
Ran 1 test in 0.010s
OK
...
Pipeline completed successfully!
Finished: SUCCESS
```

### Step 6: Break a test on purpose
Change the return text in `app.py`, push, and build again. The **Test** stage turns red, later stages are skipped and the `post { failure }` message is printed.

---

## Observations
- The Jenkinsfile lives with the code, so pipeline changes are versioned in Git.
- Stages run in order; a failure stops the pipeline.
- `post` blocks run after all stages and are useful for notifications.

## Possible Enhancements
- Use a Python virtual environment in the Build stage
- Run the app in a Docker container instead of `nohup`
- Add a webhook so GitHub triggers the build on every push

---

## Cleanup
```bash
kill $(cat python-app-deploy/app.pid)
```
