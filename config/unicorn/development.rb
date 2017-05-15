# set path to app that will be used to configure unicorn,
# note the trailing slash in this example
@dir = "#{File.expand_path(File.dirname(__FILE__))}/../../"

# Let X be your average memory usage, let B be your box's memory, and let C be your workers.
# C = (B/X).floor # e.g. (512MB/200MB).floor = 2 workers
worker_processes 2
working_directory @dir

timeout 30
preload_app false

# Dev port
listen (ENV['UNICORN_PORT'] || 9292)

# Set process id path
pid "#{@dir}tmp/pids/unicorn.pid"
