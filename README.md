# ARP Scanning and Fingerprinting Tool

This is a Docker image containing a statically built copy of arp-scan.

## About arp-scan

arp-scan is a command-line tool for system discovery and fingerprinting.  It constructs and sends ARP requests to the specified IP addresses, and displays any responses that are received.

More information can be found here: <https://github.com/royhills/arp-scan>

The official arp-scan documentation can be found on the wiki here: <http://www.royhills.co.uk/wiki/index.php/Arp-scan_Documentation>

## Running this Docker image

There are many ways to run arp-scan using different arguments.  Please refer to the documentation on the pages mentioned in the previous section for more information.  All arguments passed to the docker image will be passed directly to the arp-scan executable.

Here is a basic example of running arp-scan in Docker:

```bash
arpscan_arguments="--localnet --ignoredups"

docker run --rm -it --init \
 --network host \
 macgyverbass/arp-scan:latest \
 ${arpscan_arguments}
```

Please remember to use `--init` when running the Docker image, as the arp-scan binary will not respond to CTRL-C or `docker stop` directly.  Using `--init` tells the Docker engine to run the process under the built-in `docker-init` process, allowing the process to be terminated properly.

## Details on the Docker build

This is a multi-stage Docker image, done so to compile arp-scan statically and put the compiled binary in the final stage.

To make the final build as small as possible, it then builds the image from scratch, adding only the required binary file to the final build.  The files `ieee-iab.txt`, `ieee-oui.txt`, and `mac-vendor.txt` are also added to allow arp-scan to report additional information on devices detected.

The end result is a Docker image with only the files necessary to run arp-scan.  Thus this image is very small (about 1.12MB at the time of writing).
