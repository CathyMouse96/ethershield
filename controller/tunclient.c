#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#include <sys/ioctl.h>
#include <sys/types.h>

#include <linux/if.h>
#include <linux/if_tun.h>

int tun_alloc(char *dev) {
	struct ifreq ifr;
	int fd, err;

	if( (fd = open("/dev/net/tun", O_RDWR)) < 0 )
		return err;

	memset(&ifr, 0, sizeof(ifr));

	/* Flags: IFF_TUN   - TUN device (no Ethernet headers)
	 * 	  IFF_TAP   - TAP device
	 *
	 * 	  IFF_NO_PI - Do not provide packet information
	 */
	ifr.ifr_flags = IFF_TUN;
	if( *dev ) // char *dev should be the name of the device with a format string (e.g. "tun%d")
		strncpy(ifr.ifr_name, dev, IFNAMSIZ);

	if( (err = ioctl(fd, TUNSETIFF, (void *) &ifr)) < 0 ) {
		close(fd);
		return err;
	}
	strcpy(dev, ifr.ifr_name);
	return fd;
}

int main(int argc, char *argv[]) {
	char tun_name[IFNAMSIZ];
	int fd;

	if (argc < 2) { // Create new interface
		fd = tun_alloc("");
	} else { // Connect to existing interface
		strncpy(tun_name, argv[1], IFNAMSIZ);
		fd = tun_alloc(tun_name);
	}

	close(fd);
	return 0;
}
