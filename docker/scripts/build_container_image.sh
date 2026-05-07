#!/usr/bin/env bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source ${DIR}/set_container_vars.sh

IMAGE_NAME="${REGISTRY_REPO}:${IMAGE_TAG}"
DOCKER_FILE="Containerfile"

echo ""
echo "-----------------------------------------------------------"
echo "-- Container Image Build                                 --"
echo "-----------------------------------------------------------"
echo "Building '${IMAGE_NAME}'..."
docker build --network="host" -t ${IMAGE_NAME} --file $DOCKER_FILE .
build_result=$?
if [[ $build_result -ne 0 ]]; then
    echo ""
    echo "ERROR: Image build failed."
    exit 1
fi
echo ""
echo "Image '${IMAGE_NAME}' build success."
echo ""
echo "Cleaning up build cache..."
docker builder prune -f
echo "Done"
echo ""

exit 0
