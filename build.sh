#!/bin/bash

# Platform Layer
docker build -t tafilz/xamarin-android:platform-only ./platform
# NDK Layer
docker build -t tafilz/xamarin-android:ndk-only ./ndk

# API Levels + NDK
docker build -t tafilz/xamarin-android:26-ndk ./26/ndk
docker build -t tafilz/xamarin-android:27-ndk ./27/ndk
docker build -t tafilz/xamarin-android:28-ndk ./28/ndk
docker build -t tafilz/xamarin-android:29-ndk ./29/ndk

# API Levels
docker build -t tafilz/xamarin-android:26 ./26
docker build -t tafilz/xamarin-android:27 ./27
docker build -t tafilz/xamarin-android:28 ./28
docker build -t tafilz/xamarin-android:29 ./29
