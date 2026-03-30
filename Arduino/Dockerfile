FROM  debian:trixie-slim

RUN   useradd -ms /bin/bash runner

RUN   apt-get update && apt-get install -y \
      cmake \
      curl \
      git \
      build-essential \
      libtool \
      python-is-python3 \
      python3-pip \
      pkg-config \
      pcre2-utils \
      wget \
      jq \
      nano \
      libicu-dev
      

RUN   python -m pip install gatorgrade --break-system-packages

RUN   mkdir /tools
RUN   cd /tools && \ 
      git clone https://github.com/arduino/arduino-cli.git

ENV   ARDUINO_CLI_PATH="/tools/arduino-cli"

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

RUN cp -r /root/.arduino15 /home/runner/.arduino15
RUN chown -R runner:runner /home/runner/.arduino15
RUN usermod -aG tty runner
RUN usermod -aG dialout runner

# Runner Setup
RUN mkdir -p /home/runner/actions-runner
RUN cd /home/runner/actions-runner && \
    curl -o actions-runner-linux-x64-2.330.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.330.0/actions-runner-linux-x64-2.330.0.tar.gz && \
    tar xzf ./actions-runner-linux-x64-2.330.0.tar.gz

ADD entrypoint.sh /home/runner/entrypoint.sh
RUN chmod +x /home/runner/entrypoint.sh

RUN chown runner:runner /home/runner -R
RUN chmod o+rws /home/runner -R

USER runner

ENTRYPOINT ["/home/runner/entrypoint.sh"]