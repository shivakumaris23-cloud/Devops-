#!/bin/bash
# ==============================================================================
# Jenkins Git-to-Build Workflow Script - REVISION 2.0
# Practical Question: SET-2 QUESTION 5
# ==============================================================================

"=========================================="
" Starting Application Build Script [v2.0]"
" Build Triggered by: Jenkins Freestyle Job"
" Execution Time: $(date)"
" Current Directory: $(pwd)"
" Script Version: 2.0 (UPDATED REVISION)"
" Latest Commit Hash: $(git rev-parse --short HEAD 2>/dev/null || echo 'N/A')"
"=========================================="

"# Read configuration from supporting file if present"
'if [ -f "application.properties" ]; then'
'    echo "[INFO] Loading configuration from application.properties..."'
'    cat application.properties'
'    echo ""'
'fi'

'echo "[INFO] Running core application logic with latest enhancements..."'
'echo "[SUCCESS] Revision 2.0 executed successfully by Jenkins!"'
'echo "=========================================="'
'echo " BUILD COMPLETED SUCCESSFULLY (REVISION 2.0)"'
'echo "=========================================="'
