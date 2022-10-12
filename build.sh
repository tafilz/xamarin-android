#!/bin/bash
source defaults.sh

# Platform Layer
docker build -t ${DOCKER_HUB_USERNAME}/xamarin-android:platform-only-latest --target=platform "${COMMON_BUILD_ARGS[@]}" .
# NDK Layer
docker build -t ${DOCKER_HUB_USERNAME}/xamarin-android:ndk-only-latest --target=ndk "${COMMON_BUILD_ARGS[@]}" .

for tag in ${EXTRA_TAGS[@]}
do
  echo "Tagging ${DOCKER_HUB_USERNAME}/xamarin-android:platform-only-latest as ${DOCKER_HUB_USERNAME}/xamarin-android:platform-only-${tag}"
  docker tag "${DOCKER_HUB_USERNAME}/xamarin-android:platform-only-latest" "${DOCKER_HUB_USERNAME}/xamarin-android:platform-only-${tag}"
  echo "Tagging ${DOCKER_HUB_USERNAME}/xamarin-android:ndk-only-latest as ${DOCKER_HUB_USERNAME}/xamarin-android:ndk-only-${tag}"
  docker tag "${DOCKER_HUB_USERNAME}/xamarin-android:ndk-only-latest" "${DOCKER_HUB_USERNAME}/xamarin-android:ndk-only-${tag}"
done

for apiLevel in "${API_LEVELS[@]}"
do
  buildToolVersion=${BUILD_TOOLS[$apiLevel]}
  echo "Building for API level ${apiLevel} and build tools ${buildToolVersion}"
  # API Level
  docker build -t "${DOCKER_HUB_USERNAME}/xamarin-android:${apiLevel}-latest" --target=without_ndk  --build-arg "API_LEVEL=${apiLevel}" --build-arg "BUILD_TOOLS_VERSION=${buildToolVersion}" "${COMMON_BUILD_ARGS[@]}" .
  # API Level + NDK
  docker build -t "${DOCKER_HUB_USERNAME}/xamarin-android:${apiLevel}-ndk-latest" --target=with_ndk --build-arg "API_LEVEL=${apiLevel}" --build-arg "BUILD_TOOLS_VERSION=${buildToolVersion}" "${COMMON_BUILD_ARGS[@]}" .

  for tag in ${EXTRA_TAGS[@]}
  do
    echo "Tagging ${DOCKER_HUB_USERNAME}/xamarin-android:${apiLevel}-latest as ${DOCKER_HUB_USERNAME}/xamarin-android:${apiLevel}-${tag}"
    docker tag "${DOCKER_HUB_USERNAME}/xamarin-android:${apiLevel}-latest" "${DOCKER_HUB_USERNAME}/xamarin-android:${apiLevel}-${tag}"
    echo "Tagging ${DOCKER_HUB_USERNAME}/xamarin-android:${apiLevel}-ndk-latest as ${DOCKER_HUB_USERNAME}/xamarin-android:${apiLevel}-ndk-${tag}"
    docker tag "${DOCKER_HUB_USERNAME}/xamarin-android:${apiLevel}-ndk-latest" "${DOCKER_HUB_USERNAME}/xamarin-android:${apiLevel}-ndk-${tag}"
  done
done
