#!/bin/sh

SALON_BASIC_AUTH_TOKEN=basicsecret SALON_ADMIN_BASIC_AUTH_TOKEN=basicadminsecret bundle exec puma config.ru -C config/puma.rb -p 8081
