# dns-bind
DNS service with public and private views built into container

## Service Requirements
1. Private DNS view covering LAB environment in RFC1819 + public ranges
2. Public DNS view exposing subset of LAB environmet to public internet
3. DNS replication setup to increase resiliency of the service
4. Config of DNS for clients which would be shareable between LAN and LAB segments with automatic view enforcement based on client's IP address
5. Dynamic updates of DNS records according to RFC 2136

## Configuration updates
Either use the DynDNS feature [nsupdate](docs/Client_nsupdate.md), or update the record in zone files.

#### If modyfying zone files while DynDNS is enabled, please flush DynDNS journal to zone file and disable dynamic updates before modifying zone files - [zone-file-flush-operation](docs/zone-file-flush-operation.md).

#### Remember that zonefile's serial number must be incremented if zone file is modified.
Increment of zone serial should be +1. The usual date shaped format of zone serial is not effective for dyndns as dyndns increments the serial by one with every received update.
##### Example:
#####   Before modification
```bash
$ORIGIN .
$TTL 300	; 5 minutes
lab.rafaela.sk		IN SOA	ns1.lab.rafaela.sk. hostmaster.rafaela.sk. (
				2023100850 ; serial
```
#####   After modification
```bash
$ORIGIN .
$TTL 300	; 5 minutes
lab.rafaela.sk		IN SOA	ns1.lab.rafaela.sk. hostmaster.rafaela.sk. (
				2023100851 ; serial
```

1) add PTR record in `/opt/dns-bind/etc.bind/zones/private/<VLANnumber>.0.10.in-addr.arpa.zone` on master server (ns1.lab.rafaela.sk = 10.0.40.28 - ssh using your public key and dedicated user)
2) add A record in `/opt/dns-bind/etc.bind/zones/private/lab.rafaela.sk.zone`
3) restart the service:

```bash
cd /opt/dns-bind/
docker-compose restart
```

Zone changes should be synchronized to the slave (ns2.lab.rafaela.sk) immediately. You can check:

```bash
nslookup <dns-entry> 10.0.40.28
nslookup <dns-entry> 10.0.40.29
# or
dig <dns-entry> @10.0.40.28
dig <dns-entry> @10.0.40.29
```

### Creating a new zone file

1) Create a zone file (by copying from another) on master (ns1), e.g. 

In `/opt/dns-bind/etc.bind/zones/private/45.0.10.in-addr.arpa.zone` write:

```txt
$ORIGIN 45.0.10.in-addr.arpa.
$TTL 3600
@   IN SOA ns1.lab.rafaela.sk. hostmaster.rafaela.sk. (
        2023100301
        3600
        1800
        604800
        3600 )
    IN NS ns1.lab.rafaela.sk.
;;1     IN      PTR     ns1.lab.rafaela.sk.

;;VLAN45 .lab.rafaela.sk
158     IN      PTR     server03.lab.rafaela.sk.
```
2) Create a zone file reference in master zones on master (ns1), e.g.

In `/opt/dns-bind/etc.bind/named.conf.zones.master` add:

```txt
    zone "45.0.10.in-addr.arpa" {
        type master;
        file "/etc/bind-dns/zones/private/45.0.10.in-addr.arpa.zone";
    };
```

3) restart service on master (ns1) - see above

4) Create a zone reference to master on slave (ns2) to enable synchronization of the zone, e.g.:

```txt
    zone "45.0.10.in-addr.arpa" {
        type slave;
        masters { 10.0.40.28 key private-zone-key; };
        file "/etc/bind-dns/zones/private/45.0.10.in-addr.arpa.zone";
    };
```
5) restart service on slave (ns2) - see above

## To build and run this image:
1. copy .env.example to .env and edit .env file to set the IP address to bind to
```bash
cp .env.example .env
```

2. copy example configuration example.etc.bind to etc.bind folder:
```bash
cp -r example.etc.bind etc.bind
```

3. edit your zone configuration files in the newly created etc.bind folder

4. build image and launch it
```bash
docker-compose up -d --build
```

The --build option ensures that the Docker image is built before starting the services. If you've already built the image and just want to start the service, you can omit this option.


### Rebuilds
If there is a need for image parameter tuning, then image rebuild can be initiated using command
```bash
docker-compose build
```

## ToDo:
- test Terraform integration: https://registry.terraform.io/providers/hashicorp/dns/latest/docs
- prepare deployment of server using terraform
- manage replication keys lifecycle using vault - https://developer.hashicorp.com/hcp/docs/vault-secrets/integrations/docker
- configure DNSSEC
- a set of tests to verify all important DNS1 and DNS2 functions manually or automatically
  -   Private and Public view
  -   Zone replication
  -   selective recursion (local clients only can use DNS1 and DNS2 as a generic DNS for whole internet)
  -   Dyn DNS update through Master
  -   Dyn DNS update through Slave
  -   .local forwarding to legacy DNS server (temporary fix)
- add config example of ipv6 resolution
- add maintenance procedure flushing journal file to zone file and include manual zone file update procedure - https://serverfault.com/questions/560326/ddns-bind-and-leftover-jnl-files


## Client settings:
- [Windows](docs/Client_Win.md)
- [Linux](docs/Client_Lin.md)
- MacOS
- [Terraform](docs/Client_Terraform.md)
- [nsupdate](docs/Client_nsupdate.md) - Dyn DNS feature

## More info:
- A nice summery of ARG, ENV, .env for docker: https://vsupalov.com/docker-arg-env-variable-guide/
- Configuration: https://knot.readthedocs.io/en/master/configuration.html
- https://bind9.readthedocs.io/en/v9.18.13/chapter3.html
- https://bind9.readthedocs.io/en/v9.16.20/advanced.html#tsig
- http://www.ipamworldwide.com/ipam/update-policy.html
- https://www.zytrax.com/books/dns/ch7/xfer.html#allow-update
- https://bind9.readthedocs.io/en/v9_18_4/chapter5.html#dynamic-update
