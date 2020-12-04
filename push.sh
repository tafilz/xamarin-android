#!/bin/bash

# Platform Layer
#docker push tafilz/xamarin-android:platform-only
# NDK Layer
#docker push tafilz/xamarin-android:ndk-only

# API Levels + NDK
docker push tafilz/xamarin-android:26-ndk-latest
docker push tafilz/xamarin-android:27-ndk-latest
docker push tafilz/xamarin-android:28-ndk-latest
docker push tafilz/xamarin-android:29-ndk-latest

# API Levels
docker push tafilz/xamarin-android:26-latest
docker push tafilz/xamarin-android:27-latest
docker push tafilz/xamarin-android:28-latest
docker push tafilz/xamarin-android:29-latest
