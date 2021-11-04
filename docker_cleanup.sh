#!/bin/sh

log() {
    echo "=== [`date`] $*" >> /var/log/docker_maid.log
}

[ ! -S /var/run/docker.sock ] && (echo "Error: /var/run/docker.sock not available, bailing."; exit 1)

CONTAINERS=$(docker ps -q -a --filter "status=exited")
if [ ! -z "$CONTAINERS" ]
then
    log "Cleaning unused docker containers."
    docker rm $CONTAINERS
else
    log "No unused containers found, not cleaning."
fi

IMAGES=$(docker images -f "dangling=true" -q)
if [ ! -z "$IMAGES" ]
then
    log "Cleaning unused docker images."
    docker rmi $IMAGES
else
    log "No unused images found, not cleaning."
fi
