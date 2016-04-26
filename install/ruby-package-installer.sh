#!/bin/sh

sudo apt-get install python-software-properties
sudo apt-add-repository -y ppa:brightbox/ruby-ng
sudo apt-get update
sudo apt-get install -y ruby2.3
sudo apt-get install -y ruby2.3-dev
sudo apt-get install -y ruby-switch

#installing gems
cd /home/ubuntu/Lambda-On-OpenStack/UserInterface
sudo ./install-gems.sh