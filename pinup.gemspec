# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','pinup','version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'pinup'
  s.version = Pinup::VERSION
  s.author = 'Your Name Here'
  s.email = 'your@email.address.com'
  s.homepage = 'http://your.website.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A description of your project'
# Add your other files here if you make them
  s.files = %w(
bin/pinup
lib/pinup.rb
lib/pinup/version.rb
lib/pinup/settings.rb
lib/pinup/commands/authorize.rb
  )
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc', 'pinup.rdoc']
  s.rdoc_options << '--title' << 'pinup' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'pinup'
  s.add_dependency('colored', '~> 1.2')
  s.add_dependency('netrc', '~> 0.7.7')
  s.add_development_dependency('rake')
  s.add_development_dependency('rspec', '~> 2.13.0')
  s.add_development_dependency('cucumber', '~> 1.3.1')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
  s.add_runtime_dependency('gli','2.5.6')
end
