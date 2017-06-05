#!/usr/bin/env ruby

require 'json'
require 'yaml'

File.open('docs/swagger.json', 'w') do |f|
  f.write YAML.load(File.open('swagger.yml'){|y| y.read }).to_json
end
