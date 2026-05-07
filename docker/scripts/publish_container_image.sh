#!/usr/bin/env bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source ${DIR}/set_container_vars.sh

IMAGE_NAME="${IMAGE_NAME}:${IMAGE_TAG}"
REGISTRY_IMAGE="${REGISTRY_REPO}:${IMAGE_TAG}"

echo ""
echo "-----------------------------------------------------------"
echo "-- Publishing Container Image                            --"
echo "-----------------------------------------------------------"
echo "Tagging '${IMAGE_NAME}' as '${REGISTRY_IMAGE}'..."
docker tag ${IMAGE_NAME} ${REGISTRY_IMAGE}
if [[ $? -ne 0 ]]; then
    echo "ERROR: Tag failed."
    exit 1
fi

echo "Pushing '${REGISTRY_IMAGE}'..."
docker push ${REGISTRY_IMAGE}
if [[ $? -ne 0 ]]; then
    echo "ERROR: Push failed."
    exit 1
fi

echo ""
echo "Published '${REGISTRY_IMAGE}' successfully."
echo ""

exit 0
