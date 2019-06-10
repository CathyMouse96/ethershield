#!/bin/bash

# Set pre-shared key for tunnel
# Usage: $ set_key <INTERFACE> <KEY>
sudo ovs-vsctl set interface $1 options:psk=$2
