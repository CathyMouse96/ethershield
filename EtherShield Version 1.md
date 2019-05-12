## EtherShield Version 1

**Changes:** Proposed architecture for unprotected mode; added scripts to switch between protected mode and unprotected mode.

**Test environment:** Two virtual machines running Ubuntu 18.04 Desktop are connected by a host-only adapter. They are acting as EtherShield devices. The protected devices are simulated by [Mininet](http://mininet.org).

**IP configuration:** The IP addresses of the Mininet virtual hosts are manually configured to be `10.0.0.3` and `10.0.0.4`, respectively. In reality, they would be given by DHCP. Under unprotected mode, the virtual machines **do not have** IP addresses. Under protected mode, their IP addresses are manually configured to be the same as the IP addresses of the devices they are protecting.

**Architecture:**

![WechatIMG9](/Users/cmouse/Documents/Columbia Spring 2019/E6901 Projects in Computer Science/ethershield/WechatIMG9.jpeg)

Architecture under protected mode:

![WechatIMG15](/Users/cmouse/Documents/Columbia Spring 2019/E6901 Projects in Computer Science/ethershield/WechatIMG15.jpeg)

Architecture under unprotected mode:

![WechatIMG11](/Users/cmouse/Documents/Columbia Spring 2019/E6901 Projects in Computer Science/ethershield/WechatIMG11.jpeg)

**Switching between protected and unprotected mode:**

Switch to protected mode (`to_pro.sh`):

```sh
# 1. Delete port enp0s3 from s1
sudo ovs-vsctl del-port s1 enp0s3

# 2. Give enp0s3 same IP address as h1
sudo ifconfig enp0s3 down
sudo ifconfig enp0s3 $HOST_IP netmask $NET_MASK
sudo ifconfig enp0s3 up

# 3. Create tunnel
sudo ovs-vsctl add-port s1 s1-gre1 -- set interface s1-gre1 type=gre options:remote_ip=$REMOTE_IP
```

Switch to unprotected mode (`to_unpro.sh`):

```sh
# 1. Remove tunnel
sudo ovs-vsctl del-port s1 s1-gre1

# 2. Remove address of enp0s3
sudo ifconfig enp0s3 0

# 3. Add port enp0s3 to s1
sudo ovs-vsctl add-port s1 enp0s3
```

**Observations:**

Under protected mode, traffic between the VMs is encapsulated.

![WechatIMG14](/Users/cmouse/Documents/Columbia Spring 2019/E6901 Projects in Computer Science/ethershield/WechatIMG14.jpeg)

Under unprotected mode, traffic between the VMs is not encapsulated.

![WechatIMG13](/Users/cmouse/Documents/Columbia Spring 2019/E6901 Projects in Computer Science/ethershield/WechatIMG13.jpeg)

Traffic between the VM and the virtual host is always not encapsulated.

![WechatIMG12](/Users/cmouse/Documents/Columbia Spring 2019/E6901 Projects in Computer Science/ethershield/WechatIMG12.jpeg)

## Resolved issues from Version 0

1. ~~Try to have the test environment set up so that the VMs are manually configured to have the same IPs as the virtual hosts, not the other way. This should be fairly easy, but I still haven't figured out how to assign static IPs to VMs :/~~
2. Decide what to do about the MAC addresses. Right now, the outer Ethernet headers have the MAC addresses of the EtherShields, not the protected devices. But should this really matter? To the protected devices, all the traffic that they receive will not have the GRE headers, anyway.
3. There is the issue that **all** traffic from/to `h1` goes through the tunnel, including ARP traffic. As can be seen from the architecture diagram, `s1` is not connected to any physical port, so all traffic must go through the tunnel to reach the outside world. This differs from the setting that ARP traffic passes through the switch and only IP traffic is protected.
4. Encryption is not working; check IPsec installation.
5. Can we make the assumption that all the protected devices are on the same subnet?
6. ~~How to turn off protected mode? Need to have another port that is connected to the physical port; when protected mode is turned off, all traffic will be forwarded to that port instead of the GRE port.~~
7. Biggest question: how to establish connection? Right now everything is based on we have manually set up tunnels; how can tunnels be dynamically set up when a device wants to talk to another device?

## Proposed answers to unresolved issues

"Right now, the outer Ethernet headers have the MAC addresses of the EtherShields, not the protected devices. But should this really matter?" -> Probably not, because the encapsulation process is transparent to the protected devices.

"There is the issue that **all** traffic from/to `h1` goes through the tunnel, including ARP traffic. … This differs from the setting that ARP traffic passes through the switch and only IP traffic is protected." -> No answer yet, maybe depend on scenario; this will be a problem if we want to allow unprotected Layer 2 traffic.

"Encryption is not working; check IPsec installation." -> No answer yet, will fix.

"Can we make the assumption that all the protected devices are on the same subnet?" -> Probably yes, and if not, could probably establish tunnel with router (?).

"Biggest question: how to establish connection? Right now everything is based on we have manually set up tunnels; how can tunnels be dynamically set up when a device wants to talk to another device?" -> Straightforward way is to just set up tunnels in advance with every device on the network, but maybe need more flexible solutions?