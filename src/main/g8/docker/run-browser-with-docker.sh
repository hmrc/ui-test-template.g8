#!/bin/bash

# If service-manager is running, you can retrieve all running application ports using "sm -s" like so:
port_mappings=\$(sm -s | grep PASS | awk '{ print \$12"->"\$12 }' | paste -sd "," -)

# Alternately, you can explicitly list the port mappings the browser container required by initialising 'port_mappings' as below:
#port_mappings="9032->9032,9250->9250,9080->9080"

docker run \
  -d \
  --rm \
  --name \${1} \
  -p 4444:4444 \
  -p 5900:5900 \
  -e PORT_MAPPINGS=\$port_mappings \
  -e TARGET_IP='host.docker.internal' \
  \${1}

# For Linux users:
#   set TARGET_IP='localhost' and add the docker run option "--net=host"
#   see details https://stackoverflow.com/questions/48546124/what-is-linux-equivalent-of-host-docker-internal