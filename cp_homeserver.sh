#!/bin/sh

rsync -avR --delete ./anmeldetool-web/src/main/web/dist/at-app/./ root@192.168.99.10:/root/anmeldetool/at-app/
rsync -avR --delete ./anmeldetool-server/target/./anmeldetool-0.0.1-SNAPSHOT.jar root@192.168.99.10:/root/anmeldetool/backend/
rsync -avR --delete ./docker-prod/./ root@192.168.99.10:/root/anmeldetool/docker
rsync -avR --delete ./cp_webserver.sh root@192.168.99.10:/root/anmeldetool/
