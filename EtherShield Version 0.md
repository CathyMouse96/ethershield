## EtherShield Version 0.0

**Test environment:** Two virtual machines running Ubuntu 18.04 Desktop are connected by a host-only adapter. They are acting as EtherShield devices. The protected devices are simulated by [Mininet](http://mininet.org).

**IP configuration:** The IP addresses of the virtual machines are given by DHCP (`10.0.0.3` and `10.0.0.4`, respectively). The mininet hosts are manually configured to have IPs in a different subnet than the virtual machines, but in the same subnet as each other (`192.168.0.1` and `192.168.0.2`, respectively). The next step is to have them all belong in the same subnet, and the final step is to make the EtherShields have the same IPs as the protected devices.

**Architecture:**

![WechatIMG3](/Users/cmouse/Documents/Columbia Spring 2019/E6901 Projects in Computer Science/WechatIMG3.jpeg)

**Tunnel establishment:**

On VM1:

```sh
sudo mn --topo=linear,1
mininet> py h1.setIP('192.168.0.1/24') # assign IP to device
mininet> sh ovs-vsctl add-port s1 s1-gre1 -- set interface s1-gre1 type=gre options:remote_ip=10.0.0.4 options:psk=swordfish # establish tunnel
```

On VM2:

```sh
sudo mn --topo=linear,1
mininet> py h1.setIP('192.168.0.2/24') # assign IP to device
mininet> sh ovs-vsctl add-port s1 s1-gre1 -- set interface s1-gre1 type=gre options:remote_ip=10.0.0.3 options:psk=swordfish # establish tunnel
```

**Observations:**

The two protected devices can ping each other. On the `s1-eth1` interface, we see regular `icmp` traffic. On the VM's `eth0` interface, we see encapsulated traffic (encryption did not seem to work - will fix this issue later).

![WechatIMG5](/Users/cmouse/Documents/Columbia Spring 2019/E6901 Projects in Computer Science/WechatIMG5.jpeg)

![WechatIMG6](/Users/cmouse/Documents/Columbia Spring 2019/E6901 Projects in Computer Science/WechatIMG6.jpeg)



## EtherShield Version 0.1

**IP configuration:** The mininet hosts and the virtual machines now belong in the same subnet. Hosts: `10.0.0.11` and `10.0.0.12`, respectively. VMs: `10.0.0.3` and `10.0.0.4`, respectively.

**Tunnel establishment:**

On VM1:

```sh
sudo mn --topo=linear,1
mininet> py h1.setIP('10.0.0.11/8')
mininet> sh ovs-vsctl add-port s1 s1-gre1 -- set interface s1-gre1 type=gre options:remote_ip=10.0.0.4 options:psk=swordfish
```

On VM2:

```sh
sudo mn --topo=linear,1
mininet> py h1.setIP('10.0.0.12/8')
mininet> sh ovs-vsctl add-port s1 s1-gre1 -- set interface s1-gre1 type=gre options:remote_ip=10.0.0.3 options:psk=swordfish
```

**Observations:**

The two protected devices can still ping each other. There is no difference as when the protected devices were in different subnets than the VMs.



## EtherShield Version 0.2

**IP configuration:** Now we try to set the EtherShields and their protected devices to have the same IP address. We set the IP addresses of the virtual hosts to `10.0.0.3` and `10.0.0.4`, respectively.

**Observations:**

For some reason this still worked even though I thought it wouldn't. But it makes sense - it doesn't matter that `h1` has the same IP address as the VM's `eth0`. All GRE traffic coming in from `eth0` will go to `s1-gre1`, and since `h1` is the only device with IP address `10.0.0.3` connected to `s1`, traffic will go to `h1`.



## Issues for Version 1

1. Try to have the test environment set up so that the VMs are manually configured to have the same IPs as the virtual hosts, not the other way. This should be fairly easy, but I still haven't figured out how to assign static IPs to VMs :/
2. Decide what to do about the MAC addresses. Right now, the outer Ethernet headers have the MAC addresses of the EtherShields, not the protected devices. But should this really matter? To the protected devices, all the traffic that they receive will not have the GRE headers, anyway.
3. There is the issue that **all** traffic from/to `h1` goes through the tunnel, including ARP traffic. As can be seen from the architecture diagram, `s1` is not connected to any physical port, so all traffic must go through the tunnel to reach the outside world. This differs from the setting that ARP traffic passes through the switch and only IP traffic is protected.
4. Encryption is not working; check IPsec installation.
5. Can we make the assumption that all the protected devices are on the same subnet?
6. How to turn off protected mode? Need to have another port that is connected to the physical port; when protected mode is turned off, all traffic will be forwarded to that port instead of the GRE port.
7. Biggest question: how to establish connection? Right now everything is based on we have manually set up tunnels; how can tunnels be dynamically set up when a device wants to talk to another device?



**References:**

OVS IPsec Tutorial: http://docs.openvswitch.org/en/latest/tutorials/ipsec/

Connecting VMs Using Tunnels: http://docs.openvswitch.org/en/latest/howto/tunneling/

Connecting two Mininet networks with GRE tunnel – Part 2: https://techandtrains.com/2014/01/20/connecting-two-mininet-networks-with-gre-tunnel-part-2/

Examining Open vSwitch Traffic Patterns: https://blog.scottlowe.org/2013/05/15/examining-open-vswitch-traffic-patterns/#scenario-3-the-isolated-bridge