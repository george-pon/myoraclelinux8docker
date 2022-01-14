#!/bin/bash
#
# リポジトリにpushする
#

TAG_LIST=$(awk '/^ENV MYORACLELINUX8DOCKER_VERSION/ {print $3;}' Dockerfile)
TAG_LIST="$TAG_LIST monthly$(date +%Y%m) "
IMAGE_NAME=$(awk '/^ENV MYORACLELINUX8DOCKER_IMAGE/ {print $3;}' Dockerfile)

REPO_SERV=${REPO_SERV:-docker.io/georgesan/}

for i in $TAG_LIST
do
    echo $SUDO_DOCKER docker tag ${IMAGE_NAME}:$i ${REPO_SERV}${IMAGE_NAME}:$i
    $SUDO_DOCKER docker tag ${IMAGE_NAME}:$i ${REPO_SERV}${IMAGE_NAME}:$i
    echo $SUDO_DOCKER docker push ${REPO_SERV}${IMAGE_NAME}:$i
    $SUDO_DOCKER docker push ${REPO_SERV}${IMAGE_NAME}:$i
done

