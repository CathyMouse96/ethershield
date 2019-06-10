#!/bin/bash

# Create tunnel
# Usage: $ create_tunnel <INTERFACE> <REMOTE_IP>
sudo ovs-vsctl add-port s1 $1 -- set interface s1-gre1 type=gre options:remote_ip=$2 options:psk=swordfish
