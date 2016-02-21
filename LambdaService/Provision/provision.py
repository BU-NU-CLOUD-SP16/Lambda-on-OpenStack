#!/usr/bin/env python
import os
from credentials import get_nova_credentials_v2
from novaclient.client import Client
import urllib3.contrib.pyopenssl
urllib3.contrib.pyopenssl.inject_into_urllib3()
import time
import subprocess
import sys

#CONSTANTS
KEY_NAME = "moc-key"
PUBLIC_KEY_PATH= '/home/ubuntu/.ssh/id_rsa.pub'
IMAGE_NAME="Centos 7"
FLAVOR_NAME="m1.medium"
NETWORK_NAME="test-network"
SERVER_NAME="vm2"
USERNAME="centos"

#get credentials
def get_nova_client():
	credentials = get_nova_credentials_v2()
	nova_client = Client(**credentials)
	return nova_client

# wait till the status of the instance is active
def wait_until_active(instance,nova_client):
	status=instance.status
        while status == 'BUILD':
        	time.sleep(5)
   		 # Retrieve the instance again so the status field updates
        	instance = nova_client.servers.get(instance.id)
                status = instance.status
	print "status: %s" % status

#create a public key if it already does not exist
def transfer_public_key(nova_client):
	if not nova_client.keypairs.findall(name=KEY_NAME):
        	with open(os.path.expanduser(PUBLIC_KEY_PATH)) as fpubkey:
                	nova_client.keypairs.create(name=KEY_NAME, public_key=fpubkey.read())

	return nova_client

def get_server_object_details(nova_client):
	server_details ={}
	image = nova_client.images.find(name=IMAGE_NAME)
        flavor = nova_client.flavors.find(name=FLAVOR_NAME)
        net = nova_client.networks.find(label=NETWORK_NAME)
	server_details = {"image":image,"flavor":flavor,"net":net}
	return server_details



def create_instance(nova_client):
	try:
        	nova_client = transfer_public_key(nova_client)
        	print(nova_client.servers.list())
		server_details = get_server_object_details(nova_client)
        	nics = [{'net-id': server_details["net"].id}]
        	instance = nova_client.servers.create(name=SERVER_NAME, image=server_details["image"],
        					flavor=server_details["flavor"], nics=nics,key_name=KEY_NAME,security_groups=["SSH","default"])
        	print("Sleeping for 5s after create command")
		wait_until_active(instance,nova_client)
        	time.sleep(5)
        	print("List of VMs")
       	        print(nova_client.servers.list())

	finally:
        	print("Execution Complete")


def delete_instance(nova_client):
	servers_list = nova_client.servers.list()
	server_del = SERVER_NAME
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

def deploy_and_execute(nova_client):
	server= nova_client.servers.find(name=SERVER_NAME)
	server=server.networks[NETWORK_NAME][0]
	print server
	try:
		copy=subprocess.check_output("scp -o LogLevel=quiet -o StrictHostKeyChecking=no helloworld.py "+USERNAME+"@"+server+":~",shell=True)
		perm=subprocess.check_output("ssh -o LogLevel=quiet -o StrictHostKeyChecking=no "+USERNAME+"@"+server+" 'chmod 711 ~/helloworld.py'",shell=True)
		run=subprocess.check_output("ssh -o LogLevel=quiet -o StrictHostKeyChecking=no "+USERNAME+"@"+server+" '"+"DISPLAY=:0 ./helloworld.py >helloworld.log"+"'",shell=True)
		print "deployed and executed"
	except subprocess.CalledProcessError as e:
    		output = e.output


if __name__ == '__main__':
	nova_client = get_nova_client()
	delete_instance(nova_client)
	create_instance(nova_client)
	time.sleep(20)
	deploy_and_execute(nova_client)
