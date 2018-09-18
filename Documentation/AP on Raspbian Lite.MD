:one: Download [Raspbian Stretch](https://www.raspberrypi.org/downloads/raspbian/) and unzip

:two: Create bootable flash card using [Win32DiskImager](https://sourceforge.net/projects/win32diskimager/)

:three: Set static IP for device for using via SSH, copy [file content](https://github.com/alexeysilyuk/Graduating-Project/edit/master/Documentation/dhcpcd.conf) to your file /etc/dhcpcd.conf

:four: Carefully follow [this instruction](https://www.raspberrypi.org/documentation/configuration/wireless/access-point.md) to make Raspberry being Access point

  Note! run "iptables-restore < /etc/iptables.ipv4.nat" with sudo !
