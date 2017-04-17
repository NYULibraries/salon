#!/bin/bash

echo "Killing unicorn process..."
kill -QUIT `cat tmp/pids/unicorn.pid`
