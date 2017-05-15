#!/bin/bash

echo "Removing existing unicorn pid..."
rm -rf tmp/pids/unicorn.pid

echo "Running unicorn..."
if [ "$1" == "production" ]; then
  bundle exec unicorn -c config/unicorn/production.rb -E production
else
  bundle exec unicorn -c config/unicorn/development.rb
fi
