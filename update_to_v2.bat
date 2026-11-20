@echo off
REM ==============================================================================
REM Step 5 Automation: Update to Version 2.0 and Push to GitHub
REM ==============================================================================
echo [1/3] Updating hello.sh and application.properties to Version 2.0...

(
echo #!/bin/bash
echo # ==============================================================================
echo # Jenkins Git-to-Build Workflow Script - REVISION 2.0
echo # Practical Question: SET-2 QUESTION 5
echo # ==============================================================================
echo.
echo "=========================================="
echo " Starting Application Build Script [v2.0]"
echo " Build Triggered by: Jenkins Freestyle Job"
echo " Execution Time: $(date)"
echo " Current Directory: $(pwd)"
echo " Script Version: 2.0 (UPDATED REVISION)"
echo " Latest Commit Hash: $(git rev-parse --short HEAD 2>/dev/null || echo 'N/A')"
echo "=========================================="
echo.
echo "# Read configuration from supporting file if present"
echo 'if [ -f "application.properties" ]; then'
echo '    echo "[INFO] Loading configuration from application.properties..."'
echo '    cat application.properties'
echo '    echo ""'
echo 'fi'
echo.
echo 'echo "[INFO] Running core application logic with latest enhancements..."'
echo 'echo "[SUCCESS] Revision 2.0 executed successfully by Jenkins!"'
echo 'echo "=========================================="'
echo 'echo " BUILD COMPLETED SUCCESSFULLY (REVISION 2.0)"'
echo 'echo "=========================================="'
) > hello.sh

(
echo # Supporting Source File for Jenkins Freestyle Build Project
echo APP_NAME=DevOps-Jenkins-Build
echo APP_ENV=Production
echo VERSION=2.0.0
echo AUTHOR=Shivakumar
echo COLLEGE=BMSCE
echo STATUS=UPDATED_REVISION
) > application.properties

(
echo @echo off
echo echo ==========================================
echo echo  Starting Application Build Script [v2.0]
echo echo  Build Triggered by: Jenkins Freestyle Job
echo echo  Execution Time: %%DATE%% %%TIME%%
echo echo  Current Directory: %%CD%%
echo echo  Script Version: 2.0 (UPDATED REVISION)
echo echo ==========================================
echo if exist application.properties (
echo     echo [INFO] Loading configuration from application.properties...
echo     type application.properties
echo     echo.
echo ^)
echo echo [INFO] Running core application logic with latest enhancements...
echo echo [SUCCESS] Revision 2.0 executed successfully by Jenkins!
echo echo ==========================================
echo echo  BUILD COMPLETED SUCCESSFULLY (REVISION 2.0)
echo echo ==========================================
) > run_build.bat

echo [2/3] Committing changes to local Git repository...
git add hello.sh application.properties run_build.bat
git commit -m "Step 5: Update hello.sh to Version 2.0 to demonstrate revision retrieval"

echo [3/3] Pushing changes to remote GitHub repository...
git push origin main

echo.
echo ===============================================================
echo Done! Changes pushed to GitHub.
echo Now open Jenkins, click 'Build Now' (Build #2), and check Console Output!
echo ===============================================================
pause
