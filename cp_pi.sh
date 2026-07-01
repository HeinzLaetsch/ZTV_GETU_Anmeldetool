#!/bin/sh

rsync -avR --delete ./at-app/ getu@192.168.99.198:~/anmeldetool/
rsync -avR --delete ./backend/anmeldetool-0.0.1-SNAPSHOT.jar getu@192.168.99.198:~/anmeldetool/
rsync -avR --delete ./docker/ getu@192.168.99.198:~/anmeldetool/

