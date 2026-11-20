# Jenkins Git-to-Build Workflow with a Freestyle Project

**SET 2 • PRACTICAL QUESTIONS - QUESTION 5**
- **Repository URL:** `https://github.com/shivakumaris23-cloud/Devops-`
- **Branch:** `main`
- **Author:** Shivakumar (`shivakumar.is23@bmsce.ac.in`)

---

## Overview & Scenario
A developer commits a small application script to GitHub. Jenkins must retrieve the latest source code from GitHub and execute it automatically as part of a repeatable Freestyle build job.

---

## Mandatory Execution Steps

### Step 1: Initialize Git and Commit Source Files
- Shell script: `hello.sh`
- Supporting source file: `application.properties`
- Windows execution runner: `run_build.bat`
- Git initialized locally with author details configured.

```bash
git init
git config user.name "Shivakumar"
git config user.email "shivakumar.is23@bmsce.ac.in"
git add .
git commit -m "Initial commit: Add shell script and supporting source files"
```

---

### Step 2: Add Remote and Push to GitHub
Connect local git repository to GitHub and push `main`:

```bash
git branch -M main
git remote add origin https://github.com/shivakumaris23-cloud/Devops-.git
git push -u origin main
```

Verify commit and files on GitHub:
- `https://github.com/shivakumaris23-cloud/Devops-`

---

### Step 3: Create Freestyle Project in Jenkins & Configure Git SCM
1. Open Jenkins Dashboard (`http://localhost:8080`).
2. Click **New Item**.
3. Enter Project Name: `DevOps-Git-Freestyle-Build`.
4. Select **Freestyle project** and click **OK**.
5. Under **Source Code Management**:
   - Select **Git**.
   - **Repository URL:** `https://github.com/shivakumaris23-cloud/Devops-.git`
   - **Credentials:** None (if repository is public) or GitHub Personal Access Token / Credentials (if private).
   - **Branches to build:** `*/main`.

---

### Step 4: Add Build Step & Execute Job
1. Scroll down to **Build Steps**.
2. Click **Add build step**:
   - For Linux / Git Bash: Select **Execute shell** and enter:
     ```bash
     chmod +x hello.sh
     ./hello.sh
     ```
   - For Windows agents: Select **Execute Windows batch command** and enter:
     ```cmd
     run_build.bat
     ```
     *(Or if Git Bash is configured in PATH: `bash hello.sh`)*
3. Click **Save**.
4. Click **Build Now** to trigger the build.

---

### Step 5: Inspect Output, Commit Revision & Verify Rerun
1. Click on the build number (e.g., `#1`) > **Console Output**.
2. Verify:
   - Jenkins clones `https://github.com/shivakumaris23-cloud/Devops-.git` at branch `main`.
   - Script runs and prints `BUILD COMPLETED SUCCESSFULLY`.
   - Result: `Finished: SUCCESS`.
3. Update `hello.sh` or `application.properties` with a new version/message (e.g., Version 2.0).
4. Commit and push the change to GitHub:
   ```bash
   git add hello.sh
   git commit -m "Update hello.sh: version 2.0 with enhanced logging"
   git push origin main
   ```
5. In Jenkins, click **Build Now** (Build `#2`).
6. Open **Console Output** for Build `#2` to prove that Jenkins fetches the latest commit revision and executes the updated message.
