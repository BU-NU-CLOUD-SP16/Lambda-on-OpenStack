#!/bin/sh
apt-get update -y
apt-get install -y python-dev python-pip
pip install python-openstackclient

pip install ndg-httpsclient
pip install pyasn1
apt-get install libffi-dev
apt-get update -y
apt-get install -y rabbitmq-server
pip install pika
pip install pymongo
apt-get install -y git
