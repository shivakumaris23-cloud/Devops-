@echo off
REM ==============================================================================
REM Jenkins Git-to-Build Windows Batch Script
REM Practical Question: SET-2 QUESTION 5
REM ==============================================================================

echo ==========================================
echo  Starting Application Build Script (Windows)
echo  Build Triggered by: Jenkins Freestyle Job
echo  Execution Time: %DATE% %TIME%
echo  Current Directory: %CD%
echo  Script Version: 1.0
echo ==========================================

if exist application.properties (
    echo [INFO] Loading configuration from application.properties...
    type application.properties
    echo.
)

echo [INFO] Running core application logic...
echo [SUCCESS] Application script executed successfully!
echo ==========================================
echo  BUILD COMPLETED SUCCESSFULLY
echo ==========================================
