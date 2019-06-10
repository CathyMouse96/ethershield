#!/bin/bash
sudo ovs-vsctl add-port s1 enp0s3
sudo ifconfig enp0s3 0
sudo dhclient s1
