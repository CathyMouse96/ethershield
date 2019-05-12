# ethershield

## Instructions
1. Start Open vSwitch.
2. Run `sudo mn --topo=linear,1`. This creates a virtual switch and a virtual host connected to that switch.
3. You should see the mininet prompt. Inside the mininet terminal, run `py h1.setIP('10.0.0.3/8')` (replace with IP of your choice). This assigns the IP of your choice to virtual host `h1`.
4. Start a new terminal and run `sudo setup.sh`. This starts EtherShield in unprotected mode.
5. Repeat steps 1 to 4 for another virtual machine. The two VMs should be connected by a host-only adapter with DHCP disabled, because we will be manually configuring their IPs in protected mode. Remember to assign a different IP to the virtual host running on the second VM!
6. Now, the two virtual hosts should be able to ping each other!
Note: the IPs for the virtual hosts should be in the same subnet, and also in the same subnet as the host-only adapter. I.e. IP of host-only adapter is `10.0.0.1/8`, IP for one virtual host is `10.0.0.3/8`, IP for the other virtual host is `10.0.0.4/8`.
Also, note that in unprotected mode, the VMs are acting as switches and do not have IP addresses!

## Usage
Switch from unprotected mode to protected mode:
Run `to_pro.sh` (remember to change the IP addresses in the file first!). Now, when the two virtual hosts ping each other, you can see that the traffic going in and out of the VMs' Ethernet interfaces is encapsulated!

Switch from protected mode to unprotected mode:
Run `to_unpro.sh`. Now, when the two virtual hosts ping each other, the traffic going in and out of the VMs' Ethernet interfaces is regular traffic again.

## Version 1 Due 04/18/19
 - Set up strongSwan
 - Set up tunclient
 - Script to initialize Open vSwitch
 - Script to modify behavior of Open vSwitch and start/stop IPsec
 - Set up API
