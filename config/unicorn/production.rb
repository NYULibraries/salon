# set path to app that will be used to configure unicorn,
# note the trailing slash in this example
@dir = "#{File.expand_path(File.dirname(__FILE__))}/../../"

# Let X be your average memory usage, let B be your box's memory, and let C be your workers.
# C = (B/X).floor # e.g. (512MB/200MB).floor = 2 workers
worker_processes 2
working_directory @dir

timeout 15
preload_app true

# Specify path to socket unicorn listens to,
# this location because its a permissions thing
# listen "/var/run/unicorn-#{ENV['APP_NAME']}.sock", backlog: 64
listen (ENV['UNICORN_PORT'] || 8080)

# Set process id path
if ENV['APP_NAME']
  @pid_file = "#{@dir}tmp/pids/unicorn-#{ENV['APP_NAME']}.pid"
else
  @pid_file = "#{@dir}tmp/pids/unicorn.pid"
end

pid @pid_file

# Set log file paths
stderr_path "#{@dir}log/unicorn.stderr.log"
stdout_path "#{@dir}log/unicorn.stdout.log"

before_fork do |server, worker|

end

after_fork do |server, worker|

end
