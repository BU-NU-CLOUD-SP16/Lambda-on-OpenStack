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

USERNAME="centos"
KEY_FILE="mykey"
server="101.101.101.31"
nova_client=get_nova_client()
server = nova_client.servers.find(name="vm2")
print server
copy=subprocess.check_output("scp helloworld.py "+USERNAME+"@"+server+":~",shell=True)
perm=subprocess.check_output("ssh "+USERNAME+"@"+server+" 'chmod 711 ~/helloworld.py'",shell=True)
run=subprocess.check_output("ssh "+USERNAME+"@"+server+" '"+"DISPLAY=:0 ./helloworld.py >helloworld.log < /dev/null > std.out 2> std.err &"+"'",shell=True)
