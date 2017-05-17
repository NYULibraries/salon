require 'rspec/core/rake_task'

task default: %w[spec dredd docs]

RSpec::Core::RakeTask.new(:spec)

task :dredd do
  begin
    sh "redis-server --port 6380 --daemonize yes"
    sh "TEST_AUTH=test_auth_key REDIS_ADDRESS=http://localhost:6380 dredd --config dredd/config.yml"
    sh "lsof -t -i tcp:6380 | xargs kill"
  rescue StandardError => e
    sh "lsof -t -i tcp:6380 | xargs kill"
    raise e
  end
end

task :docs do
  sh "scripts/swagger_to_json.rb"
end

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
Dir.glob('tasks/*.rake').each { |r| import r }

require 'salon_loaders'
spec = Gem::Specification.find_by_name 'salon_loaders'
Dir.glob("#{spec.gem_dir}/lib/tasks/*.rake").each { |r| load r }
