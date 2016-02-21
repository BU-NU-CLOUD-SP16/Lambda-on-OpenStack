#!/usr/bin/env python
import os
from credentials import get_nova_credentials_v2
from novaclient.client import Client
import urllib3.contrib.pyopenssl
urllib3.contrib.pyopenssl.inject_into_urllib3()
import time
try:
	credentials = get_nova_credentials_v2()
	nova_client = Client(**credentials)
	
	

	if not nova_client.keypairs.findall(name="mykey"):
    		with open(os.path.expanduser('/home/ubuntu/.ssh/id_rsa.pub')) as fpubkey:
        		nova_client.keypairs.create(name="mykey", public_key=fpubkey.read())

# Create a file for writing that can only be read and written by
#	fp = os.open(private_key_filename, os.O_WRONLY | os.O_CREAT, 0o600)
#	with os.fdopen(fp, 'w') as f:
 #   		f.write(keypair.private_key)
	print(nova_client.servers.list())

	image = nova_client.images.find(name="Centos 7")
	flavor = nova_client.flavors.find(name="m1.medium")
	net = nova_client.networks.find(label="test-network")
	nics = [{'net-id': net.id}]
	security_groups = nova_client.security_groups.find(name="SSH")
	secgroup = [{'secgroup-id':security_groups.id}]
	instance = nova_client.servers.create(name="vm2", image=image,
	flavor=flavor, nics=nics,key_name="mykey",security_groups=["SSH"])

	print("Sleeping for 5s after create command")
	time.sleep(5)
	print("List of VMs")
	server=nova_client.servers.find(name="vm2")
#	print(server.addr)
	print(nova_client.servers.list())

finally:
	print("Execution Complete")
