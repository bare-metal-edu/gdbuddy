# GDBuddy

Docker image (with `compose` file) for Github Actions runner enabling "hardware-in-the-loop" testing
for the Raspberry Pi Pico WH.

## Use

Populate the `docker-compose.yml` file with appropriate settings for:
* `RUNNER_ORG`: URL for the repository or organization hosting the runner
* `RUNNER_TOKEN`: token created for the runner to add (will be automated in the future)
* Map the appropriate USB port for the device connected to the host matchine
  * This muse be mapped to `/dev/ttyACM0` (e.g. `/dev/ttyACM0:<YOUR_USB_MOUNT_POINT>`)
Once complete, run `docker compose up`.
