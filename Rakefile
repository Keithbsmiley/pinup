require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

# NOTE CI does not run all tests, some tests require valid Pinboard credentials in the netrc file
RSpec::Core::RakeTask.new do |t|
  t.pattern = FileList['spec/**/*.rb'].exclude(/authorize|command|queries/)
end

task :default => :spec
