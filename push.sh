#!/bin/bash

# Platform Layer
docker push tafilz/xamarin-android:platform-only
# NDK Layer
docker push tafilz/xamarin-android:ndk-only

# API Levels + NDK
docker push tafilz/xamarin-android:26-ndk
docker push tafilz/xamarin-android:27-ndk
docker push tafilz/xamarin-android:28-ndk
docker push tafilz/xamarin-android:29-ndk

# API Levels
docker push tafilz/xamarin-android:26
docker push tafilz/xamarin-android:27
docker push tafilz/xamarin-android:28
docker push tafilz/xamarin-android:29
