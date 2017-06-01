require 'rspec/core/rake_task'

task default: %w[spec dredd]

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
