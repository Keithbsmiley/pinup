require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new do |t|
  t.pattern = FileList['spec/**/*.rb'].exclude(/authorize|queries/)
end

task :default => :spec
