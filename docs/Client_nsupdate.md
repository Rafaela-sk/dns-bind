Dynamic DNS update can be performed using cli command nsupdate

Example:
```bash
nsupdate -k /opt/dns-bind/etc.bind/named.conf.dyndns
> server 10.0.40.28
> zone lab.rafaela.sk
> update add newhost.lab.rafaela.sk 3600 A 10.0.55.124
> send
> update del newhost.lab.rafaela.sk
> send
> quit
```

