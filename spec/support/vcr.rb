require 'vcr'
VCR.configure do |c|
  c.filter_sensitive_data('https://dev.login.library.nyu.edu') { ENV['OAUTH2_SERVER'] }
  c.filter_sensitive_data('access_token') { ENV['TOKEN'] }
  c.filter_sensitive_data('admin_access_token') { ENV['ADMIN_TOKEN'] }
  c.allow_http_connections_when_no_cassette = true
  c.default_cassette_options = { record: :new_episodes, allow_playback_repeats: true }
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.configure_rspec_metadata!
  c.hook_into :webmock
end
