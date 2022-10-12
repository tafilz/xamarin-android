#!/bin/bash

source defaults.sh

for tagPrefix in "platform-only" "ndk-only" ${API_LEVELS[@]}
do
  for tagSuffix in "latest" ${EXTRA_TAGS[@]}
  do
    docker push "${DOCKER_HUB_USERNAME}/xamarin-android:${tagPrefix}-${tagSuffix}"
  done
done
