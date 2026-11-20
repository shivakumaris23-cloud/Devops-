@echo off
REM ==============================================================================
REM Step 2: Push Initial Version (v1.0) to GitHub
REM ==============================================================================
echo [INFO] Pushing main branch to https://github.com/shivakumaris23-cloud/Devops- ...
git branch -M main
git push -u origin main
echo.
echo If prompted, enter your GitHub Personal Access Token (PAT) or credentials.
pause
