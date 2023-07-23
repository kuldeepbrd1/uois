FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu20.04
# For OpenGL support: nvidia/cudagl:11.4.2-devel-ubuntu20.04

# ENV
ENV HOME_DIR=/root/
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV ROS_DISTRO noetic
ENV INSTALL_CUSTOM_CERT=false
ENV ACRONYM_INSTALL_PATH=/tmp/acronym
ENV CERT_FILE=""

# REQUIREMENTS & CERTS :Copy requirements and any private certificates from '.docker'
COPY .docker/*.crt /usr/local/share/ca-certificates/
COPY requirements.txt /tmp/

# SHELL
SHELL ["/bin/bash", "-c"]

# Set env var INSTALL_CUSTOM_CERT if a custom certificate is to be installed
RUN if ls /usr/local/share/ca-certificates/*.crt >/dev/null 2>&1; then \
    echo "INSTALL_CUSTOM_CERT=true" >> /etc/environment; \
    export CERT_FILE=$(ls /usr/local/share/ca-certificates/*.crt | head -n 1); \
    fi 

# hotfix- cuda source error on ubuntu 20.04
RUN echo "deb [by-hash=no] http://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64 /" > /etc/apt/sources.list.d/cuda.list

# APT
RUN apt-get update -y\
    && apt-get upgrade -y \
    && DEBIAN_FRONTEND=noninteractive \
    apt-get install -q -y --no-install-recommends \
    build-essential \ 
    cmake \
    dirmngr \
    gnupg2 \
    git \
    iputils-ping \
    ca-certificates \
    nano \
    net-tools \
    python3-dev \
    python3-pip \
    python3-wheel \
    python3-opengl \
    tree \
    unzip \
    wget \
    && rm -rf /var/lib/apt/lists/* \
    && update-ca-certificates \
    && echo "alias python=python3" >> /root/.bashrc\
    && echo "alias pip=pip3" >> /root/.bashrc 

# Global CA Cert config, if custom cert file exists
RUN if [ "$INSTALL_CUSTOM_CERT" = "true" ]; then \
    cp ${CERT_FILE} '$(openssl version -d | cut -f2 -d \")/certs' \
    && cat ${CERT_FILE} >> $(python -m certifi) \
    && echo "export CERT_PATH=$(python3 -m certifi)" >> ~/.bashrc \
    && echo "export SSL_CERT_FILE=${CERT_PATH}"  >> ~/.bashrc \
    && echo "export REQUESTS_CA_BUNDLE=${CERT_PATH}"  >> ~/.bashrc;  \
    fi 


# Python requirements
RUN pip install -r /tmp/requirements.txt \
    && rm /tmp/requirements.txt 

CMD [ "/bin/bash" ]
