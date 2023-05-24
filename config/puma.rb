require 'fileutils'
# set path to app that will be used to configure unicorn,
# note the trailing slash in this example
@dir = "#{File.expand_path(File.dirname(__FILE__))}/../../"

# Let X be your average memory usage, let B be your box's memory, and let C be your workers.
# C = (B/X).floor # e.g. (512MB/20MB).floor = 2 workers
workers Integer(ENV["WEB_CONCURRENCY"] || 2)
#working_directory @dir

worker_timeout 15
preload_app!

# Specify path to socket unicorn listens to,
# this location because its a permissions thing
# listen "/var/run/unicorn-#{ENV['APP_NAME']}.sock", backlog: 64
port (ENV['PORT'] || 8080)

## create tmp/pids and logs/ in root
#pids_dir = "#{@dir}tmp/pids/"
#logs_dir = "#{@dir}log/"
#[pids_dir, logs_dir].each do |dirname|
#  unless File.directory?(dirname)
#    FileUtils.mkdir_p(dirname)
#  end
#end

## Set process id path
#if ENV['APP_NAME']
#  @pid_file = "#{pids_dir}unicorn-#{ENV['APP_NAME']}.pid"
#else
#  @pid_file = "#{pids_dir}unicorn.pid"
#end

#pid @pid_file

# Set log file paths
#stderr_path "/dev/stderr"
#stdout_path "/dev/stdout"

#before_fork do |server, worker|
#
#end
#
#after_fork do |server, worker|
#
#end
