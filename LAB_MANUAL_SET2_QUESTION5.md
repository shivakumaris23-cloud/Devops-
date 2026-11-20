# Department of Information Science & Engineering
## DevOps Practical Examination / Viva-Voce

---

### **SET - 2 QUESTION 5: Jenkins Git-to-Build Workflow with a Freestyle Project**

- **Candidate Name:** Shivakumar
- **Email:** `shivakumar.is23@bmsce.ac.in`
- **GitHub Repository:** [https://github.com/shivakumaris23-cloud/Devops-](https://github.com/shivakumaris23-cloud/Devops-)
- **Branch:** `main`
- **Project Folder:** `C:\Users\SHIVAKUMAR\Downloads\jenkins`

---

### **Objective & Scenario**
A developer commits a small application script to GitHub. Jenkins must automatically retrieve the latest source code from GitHub and execute it as part of a repeatable Freestyle build job.

---

### **Step-by-Step Execution Guide (All 5 Mandatory Steps)**

#### **Step 1: Initialize Git Locally, Create Shell Script & Supporting Source Files**
1. Navigate to the project directory:
   ```bash
   cd C:\Users\SHIVAKUMAR\Downloads\jenkins
   ```
2. Initialize Git (if not already initialized):
   ```bash
   git init
   ```
3. Configure local author details:
   ```bash
   git config user.name "Shivakumar"
   git config user.email "shivakumar.is23@bmsce.ac.in"
   ```
4. Create the application shell script `hello.sh`:
   ```bash
   #!/bin/bash
   echo "=========================================="
   echo " Starting Application Build Script"
   echo " Build Triggered by: Jenkins Freestyle Job"
   echo " Execution Time: $(date)"
   echo " Current Directory: $(pwd)"
   echo " Script Version: 1.0"
   echo "=========================================="

   # Read configuration from supporting file if present
   if [ -f "application.properties" ]; then
       echo "[INFO] Loading configuration from application.properties..."
       cat application.properties
       echo ""
   fi

   echo "[INFO] Running core application logic..."
   echo "[SUCCESS] Application script executed successfully!"
   echo "=========================================="
   echo " BUILD COMPLETED SUCCESSFULLY"
   echo "=========================================="
   ```
5. Create supporting source file `application.properties`:
   ```properties
   APP_NAME=DevOps-Jenkins-Build
   APP_ENV=Production
   VERSION=1.0.0
   AUTHOR=Shivakumar
   COLLEGE=BMSCE
   ```
6. Stage and commit files:
   ```bash
   git add .
   git commit -m "Initial commit: Add shell script and supporting source files"
   ```

---

#### **Step 2: Add Remote Repository and Push to GitHub**
1. Link remote repository:
   ```bash
   git branch -M main
   git remote add origin https://github.com/shivakumaris23-cloud/Devops-.git
   ```
2. Push the `main` branch to GitHub:
   ```bash
   git push -u origin main
   ```
   *(Or double-click `push_code.bat`)*
3. **Verification on GitHub:**
   - Open [https://github.com/shivakumaris23-cloud/Devops-](https://github.com/shivakumaris23-cloud/Devops-) in your browser.
   - Verify that `hello.sh`, `application.properties`, and `README.md` are visible with the latest commit message and timestamp.

---

#### **Step 3: Create Freestyle Project in Jenkins and Configure Git SCM**
1. Open Jenkins Dashboard (`http://localhost:8080`).
2. Click **New Item** on the left menu.
3. Enter item name: `DevOps-Git-Freestyle-Job`.
4. Select **Freestyle project** and click **OK**.
5. Under **General**:
   - Description: `Freestyle project demonstrating Git-to-Build automated workflow for SET-2 Question 5`.
6. Under **Source Code Management**:
   - Select **Git**.
   - **Repository URL:** `https://github.com/shivakumaris23-cloud/Devops-.git`
   - **Credentials:** `- none -` (for public repo) or add GitHub credentials/PAT (if private).
   - **Branches to build:** `*/main`.

---

#### **Step 4: Add Build Step, Save and Execute the Job**
1. Under **Build Steps**, click **Add build step**:
   - **Option A (Linux / Git Bash environments):**
     Select **Execute shell**:
     ```bash
     chmod +x hello.sh
     ./hello.sh
     ```
   - **Option B (Windows environments):**
     Select **Execute Windows batch command**:
     ```cmd
     run_build.bat
     ```
     *(Or: `bash hello.sh` if Git Bash is in PATH)*
2. Click **Apply** and **Save**.
3. Click **Build Now** to trigger Build `#1`.

---

#### **Step 5: Inspect Workspace & Console Output, Commit Revision and Verify Rerun**
1. **Inspect Build #1:**
   - Click on **#1** in Build History.
   - Click **Console Output**.
   - Observe:
     - Git clone fetching repository `https://github.com/shivakumaris23-cloud/Devops-.git` at commit `v1.0`.
     - Script execution output showing `Script Version: 1.0`.
     - Result: `Finished: SUCCESS`.
   - Click **Workspace** in the left sidebar to verify all repository files are present on the Jenkins server workspace.
2. **Commit and Push Changed Message (Revision 2.0):**
   - Run `update_to_v2.bat` or manually modify `hello.sh`:
     ```bash
     git add hello.sh application.properties
     git commit -m "Update hello.sh to Version 2.0 to demonstrate revision retrieval"
     git push origin main
     ```
3. **Rerun Job (Build #2):**
   - In Jenkins, click **Build Now**.
   - Click on **#2** > **Console Output**.
   - Observe that Jenkins detects the new commit hash, checks out the updated revision, and displays `Script Version: 2.0 (UPDATED REVISION)`.
   - This proves that Jenkins successfully retrieves and builds the latest revision!

---

### **Expected Console Output Samples**

#### **Console Output - Build #1 (Initial Revision)**
```text
Started by user Shivakumar
Running as SYSTEM
Building in workspace C:\ProgramData\Jenkins\.jenkins\workspace\DevOps-Git-Freestyle-Job
The recommended git tool is: NONE
using credential
 > git.exe rev-parse --resolve-git-dir C:\ProgramData\Jenkins\.jenkins\workspace\DevOps-Git-Freestyle-Job\.git # timeout=10
Fetching changes from the remote Git repository
 > git.exe config remote.origin.url https://github.com/shivakumaris23-cloud/Devops-.git # timeout=10
Fetching upstream changes from https://github.com/shivakumaris23-cloud/Devops-.git
 > git.exe --version # timeout=10
 > git.exe --version # 'git version 2.55.0.windows.1'
 > git.exe fetch --tags --force --progress -- https://github.com/shivakumaris23-cloud/Devops-.git +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git.exe rev-parse "refs/remotes/origin/main^{commit}" # timeout=10
Checking out Revision 5be60b24032 (refs/remotes/origin/main)
 > git.exe config core.sparsecheckout # timeout=10
 > git.exe checkout -f 5be60b24032 # timeout=10
Commit message: "Step 1 & 2: Add shell script, properties, runner batch, and documentation"
[DevOps-Git-Freestyle-Job] $ cmd /c call ...\run_build.bat
==========================================
 Starting Application Build Script
 Build Triggered by: Jenkins Freestyle Job
 Execution Time: Fri Nov 20 11:10:00 IST 2026
 Current Directory: C:\ProgramData\Jenkins\.jenkins\workspace\DevOps-Git-Freestyle-Job
 Script Version: 1.0
==========================================
[INFO] Loading configuration from application.properties...
APP_NAME=DevOps-Jenkins-Build
APP_ENV=Production
VERSION=1.0.0
AUTHOR=Shivakumar
COLLEGE=BMSCE

[INFO] Running core application logic...
[SUCCESS] Application script executed successfully!
==========================================
 BUILD COMPLETED SUCCESSFULLY
==========================================
Finished: SUCCESS
```

#### **Console Output - Build #2 (Updated Revision 2.0)**
```text
Started by user Shivakumar
Running as SYSTEM
Building in workspace C:\ProgramData\Jenkins\.jenkins\workspace\DevOps-Git-Freestyle-Job
Fetching upstream changes from https://github.com/shivakumaris23-cloud/Devops-.git
Checking out Revision a1c89f02e7b (refs/remotes/origin/main)
Commit message: "Step 5: Update hello.sh to Version 2.0 to demonstrate revision retrieval"
[DevOps-Git-Freestyle-Job] $ cmd /c call ...\run_build.bat
==========================================
 Starting Application Build Script [v2.0]
 Build Triggered by: Jenkins Freestyle Job
 Execution Time: Fri Nov 20 11:15:20 IST 2026
 Current Directory: C:\ProgramData\Jenkins\.jenkins\workspace\DevOps-Git-Freestyle-Job
 Script Version: 2.0 (UPDATED REVISION)
==========================================
[INFO] Loading configuration from application.properties...
APP_NAME=DevOps-Jenkins-Build
APP_ENV=Production
VERSION=2.0.0
AUTHOR=Shivakumar
COLLEGE=BMSCE
STATUS=UPDATED_REVISION

[INFO] Running core application logic with latest enhancements...
[SUCCESS] Revision 2.0 executed successfully by Jenkins!
==========================================
 BUILD COMPLETED SUCCESSFULLY (REVISION 2.0)
==========================================
Finished: SUCCESS
```

---

### **Key Viva-Voce Questions & Answers**

1. **What is a Jenkins Freestyle Project?**
   - A Freestyle project is the standard, basic job type in Jenkins. It provides an intuitive web GUI to configure Source Code Management (SCM), triggers, pre-build steps, build execution scripts, and post-build actions without writing a Jenkinsfile.

2. **How does Jenkins know when new commits are available in GitHub?**
   - Through two primary methods:
     1. **GitHub Webhooks (Push-based, recommended):** GitHub notifies Jenkins immediately upon push via an HTTP POST request to `http://<jenkins-url>/github-webhook/`.
     2. **Poll SCM (Pull-based):** Jenkins periodically polls the Git repository on a schedule (e.g., `H/5 * * * *`) using cron expressions to check for new revision hashes.

3. **What is the significance of the Jenkins Workspace?**
   - The workspace is the dedicated directory on the Jenkins controller or agent where Jenkins clones the Git repository and executes build scripts. Each job has an isolated workspace directory (`<JENKINS_HOME>/workspace/<job-name>`).

4. **Why is it important to verify the Git commit hash in the Console Output?**
   - Verifying the commit hash ensures that Jenkins is pulling and executing the exact revision expected and avoids building stale or cached code.
