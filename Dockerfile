# Install galaxy on ROS
FROM ubuntu:20.04

# linux/amd64 or linux/arm64
ARG TARGETPLATFORM

# For amd64
ARG MVS_AMD=https://github.com/zhuoqiw/ros-mvs/releases/download/untagged-a7d0cf35ffdd31d0e1f0/MVS-2.1.0_x86_64_20201228.tar.gz

# For arm64
ARG MVS_ARM=https://github.com/zhuoqiw/ros-mvs/releases/download/untagged-a7d0cf35ffdd31d0e1f0/MVS-2.1.0_aarch64_20201228.tar.gz

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
  wget \
  && rm -rf /var/lib/apt/lists/*

# Download install files
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
  wget -O mvs.tar.gz  ${MVS_AMD} \
  elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
  wget -O mvs.tar.gz  ${MVS_ARM} \
  else exit(1); fi

RUN mkdir mvs \
  && tar -xzf mvs.tar.gz --strip-components=1 -C mvs
