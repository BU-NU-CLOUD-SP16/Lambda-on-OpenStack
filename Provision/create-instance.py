#!/usr/bin/env python
from credentials import get_nova_credentials_v2
from novaclient.client import Client
import time
try:
	credentials = get_nova_credentials_v2()
	nova_client = Client(**credentials)

	print(nova_client.servers.list())

	image = nova_client.images.find(name="Centos 7")
	flavor = nova_client.flavors.find(name="m1.medium")
	net = nova_client.networks.find(label="test-network")

	nics = [{'net-id': net.id}]
	instance = nova_client.servers.create(name="vm2", image=image,
	flavor=flavor, nics=nics)

	print("Sleeping for 5s after create command")
	time.sleep(5)
	print("List of VMs")
	print(nova_client.servers.list())

finally:
	print("Execution Complete")