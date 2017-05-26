#!/bin/bash
export TEST_AUTH=test_auth_key
bundle exec unicorn -p 8081
