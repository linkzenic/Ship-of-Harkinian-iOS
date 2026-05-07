#!/usr/bin/env bash

set -e

git config --global --add safe.directory '*'

echo "sdk.dir=${ANDROID_SDK_ROOT}" > /workspace/local.properties
echo "ndk.dir=${ANDROID_NDK_HOME}" >> /workspace/local.properties

exec "$@"
