#!/usr/bin/env python
import os
from credentials import get_nova_credentials_v2
from novaclient.client import Client
import urllib3.contrib.pyopenssl
urllib3.contrib.pyopenssl.inject_into_urllib3()
import time
import subprocess
import sys

def get_nova_client():
	credentials = get_nova_credentials_v2()
	nova_client = Client(**credentials)
	return nova_client

def create_instance():
	try:
    
        	nova_client = get_nova_client()
        	if not nova_client.keypairs.findall(name="mykey"):
                	with open(os.path.expanduser('/home/ubuntu/.ssh/id_rsa.pub')) as fpubkey:
                        	nova_client.keypairs.create(name="mykey", public_key=fpubkey.read())
        	print(nova_client.servers.list())
		    image = nova_client.images.find(name="Centos 7")
        	flavor = nova_client.flavors.find(name="m1.medium")
        	net = nova_client.networks.find(label="test-network")
        	nics = [{'net-id': net.id}]
        	instance = nova_client.servers.create(name="vm2", image=image,
        					flavor=flavor, nics=nics,key_name="mykey",security_groups=["SSH"])
        	print("Sleeping for 5s after create command")
		status=instance.status
		while status == 'BUILD':
    			time.sleep(5)
    # Retrieve the instance again so the status field updates
    			instance = nova_client.servers.get(instance.id)
    			status = instance.status
		print "status: %s" % status
        	time.sleep(5)
        	print("List of VMs")
       	        print(nova_client.servers.list())

	finally:
        	print("Execution Complete")


def delete_instance():
	nova_client = get_nova_client()
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

def deploy_and_execute():
	USERNAME="centos"
	KEY_FILE="mykey"
	nova_client=get_nova_client()
	server= nova_client.servers.find(name="vm2")
	server=server.networks["test-network"][0]
	print server
	try:
		copy=subprocess.check_output("scp -o StrictHostKeyChecking=no helloworld.py "+USERNAME+"@"+server+":~",shell=True)
		perm=subprocess.check_output("ssh -o StrictHostKeyChecking=no "+USERNAME+"@"+server+" 'chmod 711 ~/helloworld.py'",shell=True)
		run=subprocess.check_output("ssh -o StrictHostKeyChecking=no "+USERNAME+"@"+server+" '"+"DISPLAY=:0 ./helloworld.py >helloworld.log < /dev/null > std.out 2> std.err &"+"'",shell=True)
	except subprocess.CalledProcessError as e:
    		output = e.output


if __name__ == '__main__':
	#delete_instance()
	create_instance()
	#deploy_and_execute()
