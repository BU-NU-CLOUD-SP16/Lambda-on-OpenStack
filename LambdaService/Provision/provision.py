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


class Provision:
	def __init__(self):
		self.nova_client=self.__get_nova_client()

# get credentials		
	def __get_nova_client(self):
		credentials = get_nova_credentials_v2()
		self.nova_client = Client(**credentials)
		return self.nova_client

# wait till the status of the instance is active
	def __wait_until_active(self,instance):
		status=instance.status
        	while status == 'BUILD':
        		time.sleep(5)
   		 # Retrieve the instance again so the status field updates
        		instance = self.nova_client.servers.get(instance.id)
                	status = instance.status
		print "status: %s" % status

#create a public key if it already does not exist
	def __transfer_public_key(self):
		if not self.nova_client.keypairs.findall(name=KEY_NAME):
        		with open(os.path.expanduser(PUBLIC_KEY_PATH)) as fpubkey:
                		self.nova_client.keypairs.create(name=KEY_NAME, public_key=fpubkey.read())

#build server detail object
	def __get_server_object_details(self,server_request_object):
		server_details ={}
		image = self.nova_client.images.find(name=server_request_object["image_name"])
        	flavor = self.nova_client.flavors.find(name=server_request_object["flavor_name"])
        	net = self.nova_client.networks.find(label=server_request_object["network_name"])
		server_details = {"image":image,"flavor":flavor,"net":net,"sec":["SSH","default"],"name":server_request_object["server_name"]}
		return server_details



	def create_instance(self,server_request_object):
		try:
        		self.__transfer_public_key()
        		print(self.nova_client.servers.list())
			server_details = self.__get_server_object_details(server_request_object)
        		nics = [{'net-id': server_details["net"].id}]
        		instance = self.nova_client.servers.create(name=server_details["name"], image=server_details["image"],
        					flavor=server_details["flavor"], nics=nics,key_name=KEY_NAME,security_groups=server_details["sec"])
        		print("Sleeping for 5s after create command")
			self.__wait_until_active(instance)
        		time.sleep(5)
        		print("List of VMs")
       	        	print(self.nova_client.servers.list())

		finally:
        		print("Execution Complete")


	def delete_instance(self,server_name):
		servers_list = self.nova_client.servers.list()
		server_del = server_name
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
    			self.nova_client.servers.delete(s)
	
    		print("server %s deleted" % server_del)

	def deploy_and_execute(self,deploy_request_object):
		server= self.nova_client.servers.find(name=deploy_request_object["server_name"])
		server=server.networks[deploy_request_object["network_name"]][0]
		print server
		try:
			copy=subprocess.check_output("scp -o LogLevel=quiet -o StrictHostKeyChecking=no helloworld.py "+deploy_request_object["username"]+"@"+server+":~",shell=True)
			perm=subprocess.check_output("ssh -o LogLevel=quiet -o StrictHostKeyChecking=no "+deploy_request_object["username"]+"@"+server+" 'chmod 711 ~/helloworld.py'",shell=True)
			run=subprocess.check_output("ssh -o LogLevel=quiet -o StrictHostKeyChecking=no "+deploy_request_object["username"]+"@"+server+" '"+"DISPLAY=:0 ./helloworld.py >helloworld.log"+"'",shell=True)
			print "deployed and executed"
		except subprocess.CalledProcessError as e:
    			output = e.output




# p = Provision()
# p.delete_instance("vm2")
# server_request_obj = {"image_name":"Centos 7","server_name":"vm2","flavor_name":"m1.medium","network_name":"test-network"}
# p.create_instance(server_request_obj)
# time.sleep(20)
# deploy_request_obj = {"server_name":"vm2","network_name":"test-network","username":"centos"}
# p.deploy_and_execute(deploy_request_obj)
