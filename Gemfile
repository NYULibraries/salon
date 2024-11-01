source 'https://rubygems.org'

gem 'rake', '~> 12.3'
gem 'sinatra', '~> 3.0'
gem 'rack-protection', '~> 3.0'
gem 'redis-store', '= 1.9.1' # lock due to redis gem compatibility, see: https://github.com/redis-store/redis-store/issues/358; https://github.com/redis-store/redis-store/pull/359
#gem 'unicorn', '~> 5.3.0'
gem 'puma', '~> 6.3'
gem 'json', '~> 2.3.0'
gem 'rest-client', '~> 2.0'

group :test do
  gem 'pry'
  gem 'rspec', '~> 3.7.0'
  gem 'rspec-its', '~> 1.2'
  gem 'rack-test', '~> 0.8.2', require: "rack/test"
  gem 'vcr', '~> 4'
  gem 'webmock', '~> 3'
  gem 'rexml', '~> 3.2', '>= 3.2.4' # https://stackoverflow.com/questions/65479863/rails-6-1-ruby-3-0-0-tests-error-as-they-cannot-load-rexml
  gem 'coveralls_reborn', require: false
end

gem 'sentry-raven', '~> 2'
# gem 'ddtrace', '~> 0.21.1'
gem 'prometheus-client', '~> 2.0.0'
