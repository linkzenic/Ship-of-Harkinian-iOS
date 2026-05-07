#!/usr/bin/env bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source ${DIR}/set_container_vars.sh

echo ""
echo "-----------------------------------------------------------"
echo "-- Installing Container Image                            --"
echo "-----------------------------------------------------------"
echo "Pulling '${REGISTRY_REPO}:${IMAGE_TAG}'..."
docker pull "${REGISTRY_REPO}:${IMAGE_TAG}"
if [[ $? -ne 0 ]]; then
    echo "Error: Image pull failed."
    exit 1
fi

echo "Image '${REGISTRY_REPO}:${IMAGE_TAG}' installation success"
echo ""

exit 0
