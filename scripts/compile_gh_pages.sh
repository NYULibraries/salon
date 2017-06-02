#!/bin/bash

bundle exec ruby ./scripts/swagger_to_json.rb
mv swagger.json swagger_new.json
git checkout gh-pages
mv swagger_new.json swagger.json
git add swagger.json
git commit -m "Update swagger.json"
git push
