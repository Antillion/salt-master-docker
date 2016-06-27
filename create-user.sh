#!/bin/bash
# Create main salt user
# useradd salt
# echo -e "$SALT_PASSWORD\n$SALT_PASSWORD" | passwd salt
# adduser salt sudo
# usermod -a -G adm salt # reasons unknown this must happen for access to /var/log/salt
# chown -R salt /var/cache/salt
# chown -R salt /var/log/salt
# mkdir /etc/salt/pki
# chown -R salt /etc/salt/pki


# Create the remote/API user
useradd remotesalt
echo -e "$SALT_PASSWORD\n$SALT_PASSWORD" | passwd remotesalt
