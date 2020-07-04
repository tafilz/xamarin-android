# xamarin-android
Build Xamarin.Forms and Xamarin.Android projects in a docker container 

For this docker image i used the following pages as references:
* https://hub.docker.com/r/nathansamson/xamarin-android-docker
* https://github.com/chiticariu/xamarin-android
* https://github.com/Crashdummyy/XamarinRiderDev

# Included packages
## Android SDK
> Before using this container, you should agree with [Android SDK License Agreement](https://developer.android.com/studio/terms.html)

Installed Android SDK Platform Tools (selected by `tag`):
* API Level 26
* API Level 27
* API Level 28
* API Level 29
* Select tag `<level>-ndk`to include the `ndk-bundle`


## .NET Core
Using dotnet-sdk-3.1 from https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb

## Mono
Using `preview-focal` repo from mono-project.com

## Xamarin Android OSS Linux
Using the latest master artifact from [here](https://dev.azure.com/xamarin/public/_build?definitionId=48&_a=summary).


## Paths
* Xamarin: `/xamarin/bin/Release/bin`
* Android SDK: `/usr/lib/android-sdk`
* Android NDK: `/usr/lib/android-sdk/ndk-bundle`
* Android CMD Tools: `usr/lib/android-sdk/cmdline-tools/tools/bin`

# Example `.gitlab.ci`
```yml
stages:
  - build

build-android:
  image: tafilz/xamarin-android:29
  stage: build
  only:
    - master
  artifacts:
    paths:
      - publish_android/*.apk
    script:
      - export BUILD_DATE=$(date +%Y%m%d%H%M%S)
      - msbuild src/<solution_file_name>.sln /p:AndroidSdkDirectory=/usr/lib/android-sdk /p:Configuration="Release" /p:Platform="Any CPU" /restore
      - msbuild src/<android_project_directory>/<android_project_file_name>.csproj /p:AndroidSdkDirectory=/usr/lib/android-sdk /p:Configuration="Release" /p:Platform="Any CPU" /t:PackageForAndroid /p:OutputPath="../../publish_android/"
      - msbuild src/<android_project_directory>/<android_project_file_name>.csproj /p:AndroidSdkDirectory=/usr/lib/android-sdk /p:Configuration="Release" /p:Platform="Any CPU" /t:SignAndroidPackage /p:OutputPath="../../publish_android/"
```
