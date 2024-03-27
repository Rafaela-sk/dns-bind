Windows client can:
1. accept dns server as a part of openVPN configuration (ns1.rafaela.sk, ns2.rafaela.sk) - using post up script (detail below)
2. accept dns server as a part of DHCP configuration in Office


### Post up script OpenVPN
```bash
cat /usr/local/sbin/asp_vpn_dns_up.sh
#!/usr/bin/env bash

/usr/bin/resolvectl domain tun0 lab.rafaela.sk
/usr/bin/resolvectl dns tun0 XY.XY.XY.XY XZ.XZ.XZ.XZ    # Public IP address of ns1 and ns2
/usr/bin/resolvectl default-route tun0 true
```

openvpn config extension:
```bash
script-security 2
up "/usr/bin/sudo /usr/local/sbin/vpn_dns_up.sh"
```

more details:
- https://www.freedesktop.org/software/systemd/man/resolvectl.html
- https://www.freedesktop.org/software/systemd/man/systemd.network.html
