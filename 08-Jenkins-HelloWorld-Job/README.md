# Exercise 8: Creating a "Hello World" Jenkins Job

## Objective
Create the first Jenkins jobs that pull a shell script from GitHub and run it. The same script is run in two ways:
1. a **Freestyle** job (configured in the Jenkins UI)
2. a **Pipeline** job (configured using a `Jenkinsfile` stored in Git)

This shows the basic CI flow: code in Git, build triggered in Jenkins, result in the console output.

---

## Flow
```
hello-world.sh  --git push-->  GitHub repo  --checkout-->  Jenkins job  --sh-->  Console Output
```

---

## Files
| File | Purpose |
|---|---|
| `hello-world.sh` | Bash script that prints build details (job name, build number, workspace, user, host, date) and `Hello, Jenkins!` |
| `Jenkinsfile` | Declarative pipeline with Checkout and Run Script stages, plus success/failure messages |

### Jenkins environment variables used
| Variable | Meaning |
|---|---|
| `JOB_NAME` | name of the Jenkins job |
| `BUILD_NUMBER` | number of the current build (#1, #2 ...) |
| `WORKSPACE` | folder where Jenkins cloned the repo |

When the script is run outside Jenkins these are empty, so it prints default values.

---

## Part A: Put the script on GitHub

### Step 1: Create a fine grained personal access token
GitHub → **Settings → Developer settings → Personal access tokens → Fine-grained tokens** → give *Contents: Read and write* for the repo. The token is used as the password when pushing.

### Step 2: Test the script locally
```bash
chmod +x hello-world.sh
./hello-world.sh
```
```
----------------------------------------
  Jenkins Hello World Job
----------------------------------------
Job name     : local-run
Build number : 0
Workspace    : /home/shivakumar/Devops-/08-Jenkins-HelloWorld-Job
Run by user  : shivakumar
Host         : ubuntu
Date         : 2026-10-13 20:05:11
----------------------------------------
Hello, Jenkins!
Build step completed successfully.
```

### Step 3: Push to GitHub
```bash
git config --global user.name "Shivakumar"
git config --global user.email "<github-email>"
git add 08-Jenkins-HelloWorld-Job
git commit -m "exercise 8 jenkins hello world job"
git push origin main
```

---

## Part B: Freestyle job

### Step 1: Make sure Jenkins is running
```bash
docker ps | grep jenkins
```
Open `http://localhost:8080` and log in (setup done in Exercise 7).

### Step 2: Create a new item
**New Item** → name `HelloWorld` → select **Freestyle project** → **OK**.

### Step 3: Configure the job
| Section | Value |
|---|---|
| Description | Hello World! Jenkins job. |
| Source Code Management | Git → `https://github.com/shivakumaris23-cloud/Devops-.git`, branch `*/main` |
| Build Steps | **Execute shell** → `sh 08-Jenkins-HelloWorld-Job/hello-world.sh` |

Click **Save**.

### Step 4: Run the job
Click **Build Now**. Build `#1` appears under **Build History**.

### Step 5: Check the output
Build `#1` → **Console Output**:
```
Started by user admin
Running as SYSTEM
Building in workspace /var/jenkins_home/workspace/HelloWorld
The recommended git tool is: NONE
Cloning the remote Git repository
Cloning repository https://github.com/shivakumaris23-cloud/Devops-.git
 > git init /var/jenkins_home/workspace/HelloWorld
Fetching upstream changes from https://github.com/shivakumaris23-cloud/Devops-.git
Checking out Revision 4c1e9a2 (refs/remotes/origin/main)
[HelloWorld] $ /bin/sh -xe /tmp/jenkins5521873.sh
+ sh 08-Jenkins-HelloWorld-Job/hello-world.sh
----------------------------------------
  Jenkins Hello World Job
----------------------------------------
Job name     : HelloWorld
Build number : 1
Workspace    : /var/jenkins_home/workspace/HelloWorld
Run by user  : jenkins
Host         : 78a4587c55da
Date         : 2026-10-13 20:09:47
----------------------------------------
Hello, Jenkins!
Build step completed successfully.
Finished: SUCCESS
```

---

## Part C: Pipeline job (Jenkinsfile)

### Step 1: Create the job
**New Item** → `HelloWorld-Pipeline` → **Pipeline** → **OK**.

### Step 2: Configure
| Field | Value |
|---|---|
| Definition | Pipeline script from SCM |
| SCM | Git |
| Repository URL | `https://github.com/shivakumaris23-cloud/Devops-.git` |
| Branch | `*/main` |
| Script Path | `08-Jenkins-HelloWorld-Job/Jenkinsfile` |

Click **Save** → **Build Now**.

### Step 3: Output
The **Stage View** shows two green stages, *Checkout* and *Run Script*. Console output ends with:
```
[Pipeline] { (Run Script)
[Pipeline] sh
+ ./08-Jenkins-HelloWorld-Job/hello-world.sh
...
Hello, Jenkins!
Build step completed successfully.
[Pipeline] }
[Pipeline] { (Declarative: Post Actions)
[Pipeline] echo
Hello World job finished successfully
[Pipeline] End of Pipeline
Finished: SUCCESS
```

---

## Optional: Trigger builds automatically
In **Build Triggers** select **Poll SCM** with schedule `H/5 * * * *` so Jenkins checks GitHub every 5 minutes and builds when there is a new commit.

---

## Freestyle vs Pipeline
| Freestyle | Pipeline |
|---|---|
| Configured by clicking in the UI | Defined as code in a `Jenkinsfile` |
| Config is stored only in Jenkins | Config is versioned in Git with the code |
| Good for simple single-step jobs | Good for multi-stage builds (next exercise) |

---

## Observations
- Jenkins clones the repo into its workspace before running the build step.
- `JOB_NAME`, `BUILD_NUMBER` and `WORKSPACE` are set automatically by Jenkins.
- A green tick means success, red means failure; the console output shows the exact error.
- A `Permission denied` error means the script is not executable; `sh script.sh` or `chmod +x` fixes it.
