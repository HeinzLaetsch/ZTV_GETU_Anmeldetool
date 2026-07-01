#!/bin/sh

rsync -avR --delete ./anmeldetool-web/src/main/web/dist/at-app/./ getu@192.168.99.198:~/anmeldetool/at-app/
rsync -avR --delete ./anmeldetool-server/target/./anmeldetool-0.0.1-SNAPSHOT.jar getu@192.168.99.198:~/anmeldetool/backend/
# rsync -avR --delete ./docker/./ getu@192.168.99.198:~/anmeldetool/docker
