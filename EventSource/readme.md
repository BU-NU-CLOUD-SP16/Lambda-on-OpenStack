Ruby project containing a Demo service for Event source in Lambda Implementation.

Assuming you have ruby version 2.0.*

To run the service run these commands from command line:

1. gem install bundler        <!-- Supposed to install bundler, package manager for ruby/ -->
2. bundle install             <!-- Supposed to install all gems in the gemfile. -->
3. ruby FileCreateService.rb  <!-- Runs the service which creates a file and pushes a FileCreate event to a queue. -->
