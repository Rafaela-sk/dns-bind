## How to verify DNS service functions

Automated testing is not in place but recommeded test cases would be automatized to enable on demand but also continuous functionality testing.

There is a set of recommended tests to verify the DNS service after an upgrade or failure:

1. check resolving of internal IP address from internal environment (Private view):
   ```bash
   dig vcsa01.lab.rafaela.sk @ns1.lab.rafaela.sk
   dig vcsa01.lab.rafaela.sk @10.0.40.28
   dig vcsa01.lab.rafaela.sk @ns2.lab.rafaela.sk
   dig vcsa01.lab.rafaela.sk @10.0.40.29
   ```
2. check resolving of external public address from internal environment (recursion):
   ```bash
   dig www.youtube.com @ns1.lab.rafaela.sk
   dig www.youtube.com @10.0.40.28
   dig www.youtube.com @ns2.lab.rafaela.sk
   dig www.youtube.com @10.0.40.29
   ```
3. check resolving denial of internal IP address from external environment (Private view from public environment)
   ```bash
   dig vcsa01.lab.rafaela.sk @ns.rafaela.sk
   dig vcsa01.lab.rafaela.sk @37.9.175.181
   dig vcsa01.lab.rafaela.sk @8.8.8.8
   ```
4. check resolving of public address from public environment
   ```bash
   dig ns1.lab.rafaela.sk @ns1.rafaela.sk
   dig ns1.lab.rafaela.sk @81.89.49.94
   dig ns2.lab.rafaela.sk @ns1.rafaela.sk
   dig ns2.lab.rafaela.sk @81.89.49.94
   dig ns1.lab.rafaela.sk @ns2.rafaela.sk
   dig ns1.lab.rafaela.sk @90.64.240.142
   dig ns2.lab.rafaela.sk @ns2.rafaela.sk
   dig ns2.lab.rafaela.sk @90.64.240.142
   ```
5. check resolving denial of external public address from public environment
   ```bash
   dig www.youtube.com @ns1.rafaela.sk
   dig www.youtube.com @81.89.49.94
   dig www.youtube.com @ns2.rafaela.sk
   dig www.youtube.com @90.64.240.142
   ```
6. [check dyndns add request to master server](https://github.com/Rafaela-sk/dns-bind/blob/main/docs/Client_nsupdate.md)
7. [check dyndns add request to slave server](https://github.com/Rafaela-sk/dns-bind/blob/main/docs/Client_nsupdate.md)
8. verify replication of the newly created (dyndns) record from master to slave server
9. [delete te records from tests 6., 7.](https://github.com/Rafaela-sk/dns-bind/blob/main/docs/Client_nsupdate.md)
