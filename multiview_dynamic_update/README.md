# DNS Update Proxy

This folder provides two solutions for distributing a single `nsupdate` request to multiple BIND DNS `view`s. These solutions ensure that DNS updates are correctly applied to multiple zones based on predefined configurations.

## Solutions

### 1. Using `dnsdist` as a DNS Proxy

`dnsdist` is a powerful DNS load balancer that can be configured to route and duplicate DNS requests to multiple backend servers. While `dnsdist` does not natively support `nsupdate`, it can distribute normal DNS queries to different BIND views.

#### Installation

```sh
sudo apt update && sudo apt install dnsdist
```

#### Configuration Example

Create a new configuration file for `dnsdist` (e.g., `/etc/dnsdist/dnsdist.conf`):

```lua
newServer({address="192.168.1.1", name="bind-internal"})
newServer({address="203.0.113.1", name="bind-external"})

addAction(AndRule(
  QTypeRule(dnsdist.A),
  QNameRule("host.example.com")
), PoolAction({"bind-internal", "bind-external"}))
```

#### Running `dnsdist`

```sh
sudo systemctl restart dnsdist
```

Now, `dnsdist` will distribute `A` record queries for `host.example.com` to both `bind-internal` and `bind-external` servers.

---

### 2. Using a Python Script as an `nsupdate` Proxy

A Python script can be used to send `nsupdate` requests to multiple BIND views by utilizing `dnspython`.

#### Installation

```sh
pip install dnspython
```

#### Python Script

```python
import dns.tsigkeyring
import dns.update
import dns.query

# Define BIND views and their respective servers
views = {
    "internal": {
        "server": "192.168.1.1",
        "key_name": "internal-key",
        "key_secret": "BASE64_KEY",
        "ip": "192.168.1.100"
    },
    "external": {
        "server": "203.0.113.1",
        "key_name": "external-key",
        "key_secret": "BASE64_KEY",
        "ip": "203.0.113.100"
    }
}

# Execute nsupdate for each view
for view, config in views.items():
    keyring = dns.tsigkeyring.from_text({config["key_name"]: config["key_secret"]})
    update = dns.update.Update("example.com", keyring=keyring)
    update.add("host", 3600, "A", config["ip"])
    
    response = dns.query.tcp(update, config["server"])
    print(f"Update for {view} view: {response.rcode()}")
```

#### Running the Script

```sh
python nsupdate_proxy.py
```

This script will send `nsupdate` requests to both BIND views with the corresponding IP addresses.

---

## Choosing the Best Approach
- Use **dnsdist** if you need a proxy for general DNS query distribution.
- Use the **Python script** if you need a direct solution for updating DNS records in multiple BIND views.
