#!/bin/bash
# ==============================================================================
# Jenkins Git-to-Build Workflow Script
# Practical Question: SET-2 QUESTION 5
# ==============================================================================

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
