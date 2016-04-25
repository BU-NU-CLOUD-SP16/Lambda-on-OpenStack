# unzip 'LambdaOnOpenstack.zip'
# cd Lambda-on-OpenStack/UserInterface

RUBY= which ruby;

if [[ $GEM != '  ' ]]; 
	then
	echo "installing gems"
	# echo "enter system password to proceed."
	# sudo apt-get install python-software-properties
	# sudo apt-add-repository ppa:brightbox/ruby-ng
	# sudo apt-get update
	# sudo apt-get install ruby2.3
	# sudo apt-get install ruby-switch
	sudo gem install bundler
	sudo bundle update
else
	echo "Ruby is not installed"
fi
