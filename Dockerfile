FROM  debian:trixie-slim

RUN   useradd -ms /bin/bash runner

RUN   apt-get update && apt-get install -y \
      gcc-arm-none-eabi \
      cmake \
      curl \
      git \
      automake \
      autoconf \
      build-essential \
      texinfo \
      libtool \
      libftdi-dev \
      libusb-1.0.0-dev \
      python-is-python3 \
      python3-pip \
      pkg-config \
      pcre2-utils \
      gdb-multiarch \
      wget \
      jimsh \
      libjim-dev \
      jq \
      nano \ 
      libicu-dev
      

RUN   python -m pip install gatorgrade --break-system-packages

RUN   mkdir /tools
RUN   cd /tools && \ 
      git clone -b master --recurse-submodules https://github.com/raspberrypi/pico-sdk.git

ENV   PICO_SDK_PATH="/tools/pico-sdk"

RUN   cd /tools && \
      git clone https://github.com/raspberrypi/openocd --branch master --depth=1 && \
      cd openocd && \
      ./bootstrap && \
      ./configure && \
      make -j4

ENV   OPENOCD_PATH="/tools/openocd"

# Upated Cmake install
# Install dependencies needed to add the Kitware repo
RUN apt-get update && apt-get install -y wget gpg software-properties-common

# Add Kitware's APT signing key & repository
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc \
    | gpg --dearmor -o /usr/share/keyrings/kitware-archive-keyring.gpg && \
    echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/debian/ trixie main' \
    > /etc/apt/sources.list.d/kitware.list

RUN   mkdir runner
RUN   cd runner && \
      curl -o actions-runner-linux-x64-2.330.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.330.0/actions-runner-linux-x64-2.330.0.tar.gz && \
      tar xzf ./actions-runner-linux-x64-2.330.0.tar.gz

ADD   entrypoint.sh entrypoint.sh
RUN   chmod +x entrypoint.sh

ADD   openocd-helpers.tcl /tools/openocd-helpers.tcl

RUN   chown runner:runner /home/runner -R
RUN   chmod o+rws /home/runner -R

USER  runner

ENTRYPOINT  /entrypoint.sh
