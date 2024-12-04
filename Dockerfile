FROM debian

ENV   RUNNER_TOKEN=""

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
      python3 \
      python-is-python3 \
      python3-pip \
      pkg-config \
      pcregrep \
      gdb-multiarch

RUN   python -m pip install gatorgrade --break-system-packages

RUN   mkdir /tools
RUN   cd /tools && \ 
      git clone -b master --recurse-submodules https://github.com/raspberrypi/pico-sdk.git && \
      cd pico-sdk && \
      git reset --hard 6a7db34

ENV   PICO_SDK_PATH="/tools/pico-sdk"

RUN   cd /tools && \
      git clone https://github.com/raspberrypi/openocd.git --branch rp2040 --depth=1 && \
      cd openocd && \
      ./bootstrap && \
      ./configure && \
      make -j4

ENV   OPENOCD_PATH="/tools/openocd"

RUN   mkdir -p /tools/cmocka
RUN   cd /tools/cmocka && \
      wget https://cmocka.org/files/1.1/cmocka-1.1.7.tar.xz && \
      tar -xvf cmocka-1.1.7.tar.xz && \
      cd cmocka-1.1.7 && mkdir -p build && cd build && \
      cmake .. && make && make install

RUN   mkdir runner
RUN   cd runner && \
      curl -o actions-runner-linux-x64-2.320.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.320.0/actions-runner-linux-x64-2.320.0.tar.gz && \
      tar xzf ./actions-runner-linux-x64-2.320.0.tar.gz

ADD   entrypoint.sh entrypoint.sh
RUN   chmod +x entrypoint.sh

ADD   openocd-helpers.tcl /tools/openocd-helpers.tcl

RUN   chown runner:runner /home/runner -R
RUN   chmod o+rws /home/runner -R

USER  runner

ENTRYPOINT  /entrypoint.sh
