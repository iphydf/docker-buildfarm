FROM ubuntu:18.04
MAINTAINER iphydf@gmail.com

RUN apt-get update && apt-get install --no-install-recommends -y \
            bash-completion \
            ca-certificates \
            openjdk-8-jdk-headless \
            g++ \
            git \
            patch \
            unzip \
            wget \
            zlib1g-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Install bazel.
RUN wget -q https://github.com/bazelbuild/bazel/releases/download/0.17.1/bazel_0.17.1-linux-x86_64.deb \
 && dpkg -i bazel_0.17.1-linux-x86_64.deb \
 && rm bazel_0.17.1-linux-x86_64.deb

# Download and build buildfarm.
RUN git clone https://github.com/bazelbuild/bazel-buildfarm \
 && cd bazel-buildfarm \
 && bazel build //src/main/java/build/buildfarm:buildfarm-server_deploy.jar \
                //src/main/java/build/buildfarm:buildfarm-worker_deploy.jar \
 && cp bazel-bin/src/main/java/build/buildfarm/buildfarm-server_deploy.jar \
       bazel-bin/src/main/java/build/buildfarm/buildfarm-worker_deploy.jar / \
 && rm -rf $HOME/.cache/bazel \
 && cd - \
 && rm -rf bazel-buildfarm

FROM ubuntu:18.04
RUN apt-get update && apt-get install --no-install-recommends -y \
            ca-certificates \
            clang-5.0 \
            openjdk-8-jdk-headless \
            python3 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
COPY --from=0 /buildfarm-server_deploy.jar /buildfarm-worker_deploy.jar /
COPY server/server.config worker/worker.config /config/
