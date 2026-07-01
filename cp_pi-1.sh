#!/bin/sh

rsync -avR --delete ./anmeldetool-web/src/main/web/dist/at-app/./ getu@192.168.1.1:~/anmeldetool/at-app/
rsync -avR --delete ./anmeldetool-server/target/./anmeldetool-0.0.1-SNAPSHOT.jar getu@192.168.1.1:~/anmeldetool/backend/
# rsync -avR --delete ./docker-prod/./ getu@192.168.1.1:~/anmeldetool/docker

