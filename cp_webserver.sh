#!/bin/sh

rsync -avR --delete ./at-app/ root@192.168.100.13:~/anmeldetool/
rsync -avR --delete ./backend/anmeldetool-0.0.1-SNAPSHOT.jar root@192.168.100.13:~/anmeldetool/
rsync -avR --delete ./docker/ root@192.168.100.13:~/anmeldetool/

