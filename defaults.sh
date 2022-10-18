#!/bin/bash

# Use a .env file to easily override values in your fork
if [[ -f .env ]]
then
  source .env
fi

if [[ -z $MAINTAINER ]]
then
  MAINTAINER="Tafil Avdyli <tafil@tafhub.de>"
fi

if [[ -z $DOCKER_HUB_USERNAME ]]
then
  DOCKER_HUB_USERNAME="tafilz"
fi

if [[ -z $TZ ]]
then
  TZ="UTC"
fi

if [[ -z $EXTRA_TAGS ]]
then
  EXTRA_TAGS=()
fi

if [[ $TAG_WITH_DATE = 1 || $TAG_WITH_DATE = 'yes' || $1 = '--tag-with-date' ]]
then
  EXTRA_TAGS+=($(date +%Y%m%d))
fi

# Get command line tools version from here: https://developer.android.com/studio
if [[ -z $SDK_CMD_TOOLS ]]
then
  SDK_CMD_TOOLS="8512546"
fi

# Get BUILD ID from here: https://dev.azure.com/xamarin/public/_build?definitionId=48&_a=summary&view=runs&branchFilter=5767%2C5767%2C5767
# Click on the desired commit and extract the buildId from the url
if [[ -z $XAMARIN_OSS_BUILD_ID ]]
then
  XAMARIN_OSS_BUILD_ID="54953"
fi

if [[ -z ${BUILD_TOOLS[@]} ]]
then
  # Define which API levels you want to build, and which build tools version corresponds to it.
  BUILD_TOOLS=( [26]="26.0.3" [27]="27.0.3" [28]="28.0.3" [29]="29.0.3" [30]="30.0.3" [31]="31.0.0" [32]="32.0.0" [33]="33.0.0" )
fi

# Note: The BUILD_TOOLS list is the definition. The API_LEVELS variable is a numerically sorted list of its keys.
# Bash associative arrays are in hash order. By extracting the apiLevels into a normal array,
# we can iterate over them in numerically ascending order.
API_LEVELS=()
for apiLevel in $(tr ' ' '\n' <<< ${!BUILD_TOOLS[@]} | sort -n)
do
  API_LEVELS+=( "${apiLevel}" )
done

echo "Maintainer:           ${MAINTAINER}"
echo "Docker hub username:  ${DOCKER_HUB_USERNAME}"
echo "Xamarin OSS build ID: ${XAMARIN_OSS_BUILD_ID}"
echo "SDK CMD tools ID:     ${SDK_CMD_TOOLS}"
echo "API levels:           ${API_LEVELS[@]}"
echo "Extra tags:           ${EXTRA_TAGS[@]}"

COMMON_BUILD_ARGS=(
  "--build-arg" "MAINTAINER=${MAINTAINER}"
  "--build-arg" "SDK_CMD_TOOLS=${SDK_CMD_TOOLS}"
  "--build-arg" "XAMARIN_OSS_BUILD_ID=${XAMARIN_OSS_BUILD_ID}"
)
