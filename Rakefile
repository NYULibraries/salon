require 'rspec/core/rake_task'

task default: %w[spec dredd]

RSpec::Core::RakeTask.new(:spec)

task :dredd do
  sh "TEST_AUTH=test_auth_key dredd --config dredd/config.yml"
end
