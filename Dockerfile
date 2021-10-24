# Install MVS on ROS
FROM ros:galactic

# linux/amd64 or linux/arm64
ARG TARGETPLATFORM

# For amd64
ARG MVS_AMD=https://github.com/zhuoqiw/ros-mvs/releases/download/v2.1.0/MVS-2.1.0_x86_64_20201228.tar.gz

# For arm64
ARG MVS_ARM=https://github.com/zhuoqiw/ros-mvs/releases/download/v2.1.0/MVS-2.1.0_aarch64_20201228.tar.gz

# Copy cmake package files
COPY MVSConfig.cmake MVSConfigVersion.cmake .

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
  && tar -xzf MVS.tar.gz --strip-components=1 -C MVS \
  && tar -xzf MVS/MVS.tar.gz -C /opt \
  && rm -r MVS.tar.gz MVS

# Move libraries out of <arch> and plug in cmake package files
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
  mv /opt/MVS/lib/64/* /opt/MVS/lib \
  && rm -r /opt/MVS/lib/32 /opt/MVS/lib/64; \
  elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
  mv /opt/MVS/lib/aarch64/* /opt/MVS/lib \
  && rm -r /opt/MVS/lib/aarch64; \
  else exit 1; fi \
  && mv MVSConfig.cmake MVSConfigVersion.cmake /opt/MVS

# Update ldconfig
RUN echo "/opt/MVS/lib" >> /etc/ld.so.conf.d/MVS.conf \
  && ldconfig
