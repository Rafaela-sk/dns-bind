### How to keep consistency between static zone files and journal files with dynamic updates

Dynamic updates of DNS zone files are resulting in creation and updates of journal files stored next to the static zone config files. If one wants to get static zonefile in sync with journal there are multiple options to do so:
- restart bind - journal file gets dumped to the zone file before bind shutdown. Journal file is kept on the filesystem
- management command "sync" sent using rndc tool - journal file gets dumped to the zone file. Journal file is kept on the filesystem
- management command "sync -clear" sent using rndc tool - journal file gets dumped to the zone file. Journal file is removed for the filesystem

The choice of the option depends on the action admin needs to perform.
If we just need to see consistent set of DNS records combinig static and dynamic records, then bind or container restart are sufficient

Example:
```bash
cd /opt/dns-bind
docker-compose restart
```


If we plan to make manual modifications to static zone files, then journal should be flushed to zone file and also removed from the system to prevent conflict warnings after zone file modifications. Beware of the need to increment zone's serial after manual update of a zone file.

Example:
```bash
docker exec -it bind-container bash
rndc -c /etc/bind-dns/rndc.conf -s localhost freeze                     # stop dynamic updates
rndc -c /etc/bind-dns/rndc.conf -s localhost sync -clean                # flush journals to zone files and delete journal files
```
do modifications to the zone files and then reload (reminder: increment zone's serial ID of modified zones)
```bash
rndc -c /etc/bind-dns/rndc.conf reload                                 # reload zone config
rndc -c /etc/bind-dns/rndc.conf -s localhost thaw                      # restart dynamic updates
```
