#!/usr/bin/env python
import subprocess
import sys

from credentials import get_nova_credentials_v2
from novaclient.client import Client
import urllib3.contrib.pyopenssl
urllib3.contrib.pyopenssl.inject_into_urllib3()

def get_nova_client():
        credentials = get_nova_credentials_v2()
        nova_client = Client(**credentials)
	return nova_client

def deploy_and_execute():
	USERNAME="centos"
	KEY_FILE="mykey"
	nova_client=get_nova_client()
	server = nova_client.servers.find(name="vm2")
	server = server.networks["test-network"][0]
	copy=subprocess.check_output("scp -o StrictHostKeyChecking=no  helloworld.py "+USERNAME+"@"+server+":~",shell=True)
	perm=subprocess.check_output("ssh -o StrictHostKeyChecking=no "+USERNAME+"@"+server+" 'chmod 711 ~/helloworld.py'",shell=True)
	run=subprocess.check_output("ssh -o StrictHostKeyChecking=no "+USERNAME+"@"+server+" '"+"DISPLAY=:0 ./helloworld.py >helloworld.log < /dev/null > std.out 2> std.err &"+"'",shell=True)

if __name__ == '__main__':
        #delete_instance()
        #create_instance()
        deploy_and_execute()
