#!/bin/bash

set -ex

# Install bazel.
wget -q https://github.com/bazelbuild/bazel/releases/download/0.17.1/bazel_0.17.1-linux-x86_64.deb
dpkg -i bazel_0.17.1-linux-x86_64.deb
rm bazel_0.17.1-linux-x86_64.deb

# Download buildfarm.
git clone https://github.com/bazelbuild/bazel-buildfarm

# Build buildfarm.
pushd bazel-buildfarm
bazel build //src/main/java/build/buildfarm:buildfarm-server_deploy.jar
bazel build //src/main/java/build/buildfarm:buildfarm-worker_deploy.jar
cp bazel-bin/src/main/java/build/buildfarm/buildfarm-server_deploy.jar /
cp bazel-bin/src/main/java/build/buildfarm/buildfarm-worker_deploy.jar /
rm -rf $HOME/.cache/bazel
popd

# Delete sources.
rm -rf bazel-buildfarm

# Uninstall bazel.
apt-get remove -y bazel
