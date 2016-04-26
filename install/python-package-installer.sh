#!/bin/sh
sudo apt-get update -y
sudo apt-get install -y python-dev python-pip
sudo pip install python-openstackclient

sudo pip install ndg-httpsclient
sudo pip install pyasn1
sudo apt-get install libffi-dev
sudo apt-get update -y
sudo apt-get install -y rabbitmq-server
sudo pip install pika
sudo pip install pymongo
sudo apt-get install -y git
