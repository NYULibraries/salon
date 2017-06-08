#!/bin/bash

# USAGE:
# ./start.sh {APP_NAME} {ENVIRONMENT}

# Stop existing process first, if any
./scripts/stop.sh $1

echo "Starting up unicorn..."
if [ "$2" == "production" ]; then
  bundle exec unicorn -c config/unicorn/production.rb -E production
else
  bundle exec unicorn -c config/unicorn/development.rb
fi
