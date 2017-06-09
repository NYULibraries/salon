require 'rspec/core/rake_task'

task default: %w[spec dredd docs]

RSpec::Core::RakeTask.new(:spec)

task :dredd do
  sh "TEST_AUTH=test_auth_key dredd --config dredd/config.yml"
end

task :docs do
  sh "scripts/swagger_to_json.rb"
end

# Require Salon loader rake tasks
require 'salon_loaders'
spec = Gem::Specification.find_by_name 'salon_loaders'
Dir.glob("#{spec.gem_dir}/lib/tasks/*.rake").each { |r| load r }
