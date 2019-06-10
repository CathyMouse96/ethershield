#!/bin/bash

# 1. Remove tunnel
# sudo ovs-vsctl del-port s1 s1-gre1

# 2. Remove address of enp0s3
sudo ifconfig enp0s3 0

# 3. Add port enp0s3 to s1
sudo ovs-vsctl add-port s1 enp0s3

# 4. Give IP address to internal port s1
sudo dhclient s1
