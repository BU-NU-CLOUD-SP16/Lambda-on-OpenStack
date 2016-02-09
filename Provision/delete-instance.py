#!/usr/bin/env python
from credentials import get_nova_credentials_v2
from novaclient.client import Client

credentials = get_nova_credentials_v2()
nova_client = Client(**credentials)

servers_list = nova_client.servers.list()
server_del = "vm2"
server_exists = False

for s in servers_list:
    if s.name == server_del:
        print("This server %s exists" % server_del)
        server_exists = True
        break
if not server_exists:
    print("server %s does not exist" % server_del)
else:
    print("deleting server..........")
    nova_client.servers.delete(s)
    print("server %s deleted" % server_del)