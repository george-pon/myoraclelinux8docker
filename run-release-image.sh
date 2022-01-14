#!/bin/bash
#
# test run image
#
function docker-run-myoraclelinux8docker() {
    docker pull georgesan/myoraclelinux7docker:latest
    ${WINPTY_CMD} docker run -i -t --rm \
        -e http_proxy=${http_proxy} -e https_proxy=${https_proxy} -e no_proxy="${no_proxy}" \
        docker.io/georgesan/myoraclelinux8docker:latest
}
docker-run-myoraclelinux8docker
