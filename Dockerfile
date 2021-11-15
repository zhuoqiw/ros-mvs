# Install MVS on ROS
FROM ros:galactic

# linux/amd64 or linux/arm64
ARG TARGETPLATFORM

# For amd64
ARG MVS_AMD=https://github.com/zhuoqiw/ros-mvs/releases/download/v2.1.0/MVS-2.1.0_x86_64_20201228.tar.gz

# For arm64
ARG MVS_ARM=https://github.com/zhuoqiw/ros-mvs/releases/download/v2.1.0/MVS-2.1.0_aarch64_20201228.tar.gz

# Copy cmake package files
COPY MVSConfig*.cmake ./

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
  wget \
  && rm -rf /var/lib/apt/lists/*

# Install
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
  wget -O MVS.tar.gz ${MVS_AMD} --no-check-certificate; \
  elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
  wget -O MVS.tar.gz ${MVS_ARM} --no-check-certificate; \
  else exit 1; fi \
  && mkdir MVS \
  && tar -xzf MVS.tar.gz --strip-components=1 --directory=MVS \
  && tar -xzf MVS/MVS.tar.gz --directory=/opt \
  && rm -r MVS.tar.gz MVS

# Plug in cmake package files and update ldconfig
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
  mv MVSConfigAmd64.cmake /opt/MVS/MVSConfig.cmake \
  && echo "/opt/MVS/lib/64" >> /etc/ld.so.conf.d/MVS.conf \
  elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
  mv MVSConfigArm64.cmake /opt/MVS/MVSConfig.cmake \
  && "/opt/MVS/lib/aarch64" >> /etc/ld.so.conf.d/MVS.conf \
  else exit 1; fi \
  && mv MVSConfigVersion.cmake /opt/MVS \
  && ldconfig \
  && rm MVSConfig*.cmake
