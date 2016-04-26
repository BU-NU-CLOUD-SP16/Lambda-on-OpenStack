#!/bin/sh

apt-get install python-software-properties
apt-add-repository -y ppa:brightbox/ruby-ng
apt-get update
apt-get install ruby2.3
apt-get install ruby2.3-dev
apt-get install ruby-switch

#installing gems
gem install bundler
bundle update

