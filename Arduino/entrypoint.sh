#!/bin/sh

set -e

# Extract org from URL
ORG_NAME=$(echo "$RUNNER_ORG" | awk -F/ '{print $NF}')

# Fetch the runner registration Token from GitHub API
RUNNER_TOKEN=$(curl -s -X POST \
    -H "Authorization: Bearer $GITHUB_PAT" \
    -H "Accept: application/vnd.github+json" \
    "https://api.github.com/orgs/$ORG_NAME/actions/runners/registration-token" | jq -r .token)

cd /home/runner/actions-runner

reset_arduino() {
    ARDUINO_PORT=${ARDUINO_PORT:-/dev/ttyACM0}
    ARDUINO_FQBN=${ARDUINO_FQBN:-arduino:avr:uno}
    BLANK_SKETCH_DIR=/home/runner/blank

    if [ "${RESET_ARDUINO_ON_START:-true}" != "true" ]; then
        echo "Arduino reset on start disabled."
        return
    fi

    if [ -z "$ARDUINO_FQBN" ]; then
        echo "ARDUINO_FQBN is not set. Skipping Arduino reset."
        return
    fi

    if [ ! -e "$ARDUINO_PORT" ]; then
        echo "Arduino port $ARDUINO_PORT not found. Skipping Arduino reset."
        return
    fi

    echo "Resetting Arduino board via blank sketch..."
    arduino-cli compile --fqbn "$ARDUINO_FQBN" "$BLANK_SKETCH_DIR"
    arduino-cli upload -p "$ARDUINO_PORT" --fqbn "$ARDUINO_FQBN" "$BLANK_SKETCH_DIR"
    echo "Arduino reset complete."
}

# only configure runner if not already configured
if [ ! -f .runner ]; then
    echo "Runner not configured, configuring now..."
    ./config.sh --url "$RUNNER_ORG" --token "$RUNNER_TOKEN"
else
    echo "Runner already configured, skipping config."
fi

reset_arduino

# Start the runner in the foreground because no OpenOCD
exec ./run.sh