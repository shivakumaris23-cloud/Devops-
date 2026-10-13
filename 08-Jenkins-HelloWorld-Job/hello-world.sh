#!/bin/bash
# hello-world.sh - simple script run by the Jenkins Hello World job

echo "----------------------------------------"
echo "  Jenkins Hello World Job"
echo "----------------------------------------"
echo "Job name     : ${JOB_NAME:-local-run}"
echo "Build number : ${BUILD_NUMBER:-0}"
echo "Workspace    : ${WORKSPACE:-$(pwd)}"
echo "Run by user  : $(whoami)"
echo "Host         : $(hostname)"
echo "Date         : $(date '+%Y-%m-%d %H:%M:%S')"
echo "----------------------------------------"
echo "Hello, Jenkins!"
echo "Build step completed successfully."
