#!/bin/bash

# HOST_IP=10.0.0.3
# REMOTE_IP=10.0.0.4
# NET_MASK=255.0.0.0

# 1. Delete port enp0s3 from s1
sudo ovs-vsctl del-port s1 enp0s3

# 2. Give enp0s3 same IP address as h1
# sudo ifconfig enp0s3 down
# sudo ifconfig enp0s3 $HOST_IP netmask $NET_MASK
# sudo ifconfig enp0s3 up

# 2. Give IP address to enp0s3
sudo dhclient enp0s3

# 3. Create tunnel
# sudo ovs-vsctl add-port s1 s1-gre1 -- set interface s1-gre1 type=gre options:remote_ip=$REMOTE_IP
