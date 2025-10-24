#/bin/sh

set -e

# Extract org from URL
ORG_NAME=$(echo "$RUNNER_ORG" | awk -F/ '{print $NF}')

# Fetch the runner registration Token from GitHub API
RUNNER_TOKEN=$(curl -s -X POST \
    -H "Authorization: Bearer $GITHUB_PAT" \
    -H "Accept: application/vnd.github+json" \
    "https://api.github.com/orgs/$ORG_NAME/actions/runners/registration-token" | jq -r .token)

cd /runner && \
./config.sh --url "$RUNNER_ORG" --token "$RUNNER_TOKEN" &&
./run.sh &

/tools/openocd/src/openocd \
    -c "gdb port 50000" \
    -c "tcl port 50001" \
    -c "telnet port 50002" \
    -s /tools/openocd/tcl \
    -f /tools/openocd-helpers.tcl \
    -f interface/cmsis-dap.cfg \
    -f target/rp2040.cfg \
    -c "adapter speed 1000" \
    -c "gdb_remotetimeout 5000" \
    -c "reset init" \
    -c "halt"


