#!/bin/bash

# Delete tunnel
# Usage: $ delete_tunnel <INTERFACE>
sudo ovs-vsctl del-port s1 $1
