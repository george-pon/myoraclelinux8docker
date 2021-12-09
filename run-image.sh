#!/bin/bash
#
# test run image
#
function docker-run-myoraclelinux7docker() {
    ${WINPTY_CMD} docker run -i -t --rm \
        -e http_proxy=${http_proxy} -e https_proxy=${https_proxy} -e no_proxy="${no_proxy}" \
        myoraclelinux7docker:latest
}
docker-run-myoraclelinux7docker
