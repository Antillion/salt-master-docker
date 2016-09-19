#!/bin/bash

#
# Salt-Master Run Script
#

set -e

# Log Level
LOG_LEVEL=${LOG_LEVEL:-"info"}

# Run Salt as a Deamon

service ssh start
tail -f /var/log/salt/master &
exec /usr/local/bin/salt-api --log-level=${LOG_LEVEL} & \
exec /usr/local/bin/salt-master --log-level=$LOG_LEVEL
