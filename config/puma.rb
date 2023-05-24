workers Integer(ENV["WEB_CONCURRENCY"] || 2)

worker_timeout 15
preload_app!

port (ENV['PORT'] || 8080)
