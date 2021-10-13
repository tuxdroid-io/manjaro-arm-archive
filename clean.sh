#!/bin/bash
sudo swapoff -a
sudo rm -f /swapfile
sudo rm -rf "/usr/local/share/boost"
sudo rm -rf "$AGENT_TOOLSDIRECTORY"
sudo rm -rf /usr/share/dotnet/shared/
sudo rm -rf /usr/share/dotnet/host/
sudo rm -rf /usr/share/dotnet/sdk/
sudo rm -rf "$ANDROID_SDK_ROOT"
sudo rm -rf /usr/local/lib/android
sudo rm -rf "$SWIFT_PATH"
sudo rm -rf /usr/share/swift
sudo apt-get clean
docker rmi $(docker image ls -aq)
