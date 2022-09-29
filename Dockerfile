FROM ubuntu:20.04

RUN apt-get update && apt-get install -y --no-install-recommends \
        ocl-icd-libopencl1 \
        clinfo \
        ocl-icd-opencl-dev && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/OpenCL/vendors && \
    echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ARG testvar=12345
ARG DEBIAN_FRONTEND=nointeractive
RUN apt update
RUN apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

ENV PACKAGES="build-essential libcurl4-openssl-dev software-properties-common ubuntu-drivers-common pkg-config libtool ocl-icd-* opencl-headers openssh-server ocl-icd-opencl-dev git clinfo autoconf automake libjansson-dev libevent-dev uthash-dev nodejs vim libboost-chrono-dev libboost-filesystem-dev libboost-test-dev libboost-thread-dev libevent-dev libminiupnpc-dev libssl-dev libzmq3-dev help2man ninja-build python3 libdb++-dev wget"

RUN apt update && apt install --no-install-recommends -y $PACKAGES  && \
    rm -rf /var/lib/apt/lists/* && \
    apt clean

RUN git clone https://github.com/EugeneRymarev/rad-bfgminer.git /root/rad-bfgminer
WORKDIR /root/rad-bfgminer
RUN git config --global url.https://github.com/.insteadOf git://github.com/
RUN ./autogen.sh
RUN ./configure --enable-opencl
RUN make
RUN ./bfgminer --help

