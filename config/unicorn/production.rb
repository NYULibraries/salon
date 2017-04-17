# set path to app that will be used to configure unicorn,
# note the trailing slash in this example
@dir = "#{File.expand_path(File.dirname(__FILE__))}/../../"

worker_processes 2
working_directory @dir

timeout 30

# Specify path to socket unicorn listens to,
# this location because its a permissions thing
listen "/var/run/unicorn.sock", backlog: 64

# Set process id path
pid "/app/tmp/pids/unicorn.pid"

# Set log file paths
stderr_path "#{@dir}log/unicorn.stderr.log"
stdout_path "#{@dir}log/unicorn.stdout.log"
