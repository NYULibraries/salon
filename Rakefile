require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
Dir.glob('tasks/*.rake').each { |r| import r }

require 'salon_loaders'
spec = Gem::Specification.find_by_name 'salon_loaders'
Dir.glob("#{spec.gem_dir}/lib/tasks/*.rake").each { |r| load r }
