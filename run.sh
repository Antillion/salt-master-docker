#!/bin/bash

#
# Salt-Master Run Script
#

set -e

# Log Level
LOG_LEVEL=${LOG_LEVEL:-"error"}

# Run Salt as a Deamon
service salt-api start
service ssh start
tail -f /var/log/salt/master &
exec /usr/bin/salt-master --log-level=$LOG_LEVEL
