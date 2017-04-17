#!/bin/bash

echo "Removing existing unicorn pid..."
rm -rf tmp/pids/unicorn.pid

echo "Running unicorn..."
bundle exec unicorn -c config/unicorn/production.rb -p 8080 -E production
