#!/bin/bash -x
echo 'loading bashrc'
source ~/.bashrc

echo 'loading gemset'
#cd .
rvm use ruby-2.0.0-p0@booty --create

echo 'bundle install'
bundle install

echo 'cp db config'
cp build/db/configuration.yml.template build/db/configuration.yml

echo 'run tests'
bundle exec rake ci --trace
