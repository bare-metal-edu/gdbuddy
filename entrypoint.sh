#/bin/sh

cd /runner && \
./config.sh --url $RUNNER_ORG --token $RUNNER_TOKEN &&
./run.sh &

/tools/openocd/src/openocd -c "gdb_port 50000" -c "tcl_port 50001" -c "telnet_port 50002" -s /tools/openocd/tcl -f /tools/openocd-helpers.tcl -f interface/cmsis-dap.cfg -f target/rp2040.cfg -c "adapter speed 5000"
