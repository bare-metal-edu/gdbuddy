FROM  debian:trixie-slim

RUN   useradd -ms /bin/bash runner

RUN   apt-get update --allow-releaseinfo-change && \
      apt-get install -y \
      curl \
      git \
      python-is-python3 \
      python3-pip \
      build-essential \
      cmake \
      wget \
      nano \
      jq \
      libusb-1.0-0-dev \
      ca-certificates \
      gnupg \
      libstdc++6 \
      libicu76 \
      && rm -rf /var/lib/apt/lists/*

RUN   python -m pip install gatorgrade --break-system-packages

# Create Directory for Arduino CLI
RUN mkdir -p /usr/local/bin

# Arduino CLI configuration
RUN curl -fsSL https://downloads.arduino.cc/arduino-cli/arduino-cli_latest_Linux_64bit.tar.gz \
    -o arduino-cli.tar.gz && \
    tar -xzf arduino-cli.tar.gz && \
    mv arduino-cli /usr/local/bin/arduino-cli && \
    rm arduino-cli.tar.gz && \
    chmod +x /usr/local/bin/arduino-cli

# Install Arduino Cores
RUN /usr/local/bin/arduino-cli config init && \
    /usr/local/bin/arduino-cli core update-index && \
    /usr/local/bin/arduino-cli core install arduino:avr && \
    /usr/local/bin/arduino-cli core install arduino:samd && \
    /usr/local/bin/arduino-cli core install arduino:mbed_rp2040

RUN chown -R runner:runner /root/.arduino15

# Runner Setup
RUN mkdir -p /home/runner/actions-runner
RUN cd /home/runner/actions-runner && \
    curl -o actions-runner-linux-x64-2.330.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.330.0/actions-runner-linux-x64-2.330.0.tar.gz && \
    tar xzf ./actions-runner-linux-x64-2.330.0.tar.gz

ADD Arduino/entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh

RUN chown runner:runner /home/runner -R
RUN chmod o+rws /home/runner -R

USER runner

ENTRYPOINT Arduino/entrypoint.sh