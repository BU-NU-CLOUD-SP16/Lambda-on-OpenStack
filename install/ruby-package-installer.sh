#!/bin/sh

sudo apt-get install python-software-properties
sudo apt-add-repository -y ppa:brightbox/ruby-ng
sudo apt-get update
sudo apt-get install -y ruby2.3
sudo apt-get install -y ruby2.3-dev
sudo apt-get install -y ruby-switch

#installing gems
sudo gem install bundler
#cat /home/ubuntu/Lambda-On-OpenStack/install/Gemfile | tr "\r" "\n" > /home/ubuntu/Lambda-On-OpenStack/install/Gemfile
cd /home/ubuntu/Lambda-On-OpenStack/UserInterface
bundle install
