#!/bin/bash
docker run -d --name jenkins -p 8080:8080 -p 50000:50000 jenkins/jenkins:lts

# initial admin password
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
