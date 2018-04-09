require 'rspec/core/rake_task'

task default: %w[spec dredd docs]

RSpec::Core::RakeTask.new(:spec)

task :dredd do
  sh "dredd --config dredd/config.yml"
end

task :docs do
  sh "scripts/swagger_to_json.rb"
end
