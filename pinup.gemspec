require File.join([File.dirname(__FILE__),'lib','pinup','version.rb'])
spec = Gem::Specification.new do |s| 
  s.name                  = 'pinup'
  s.version               = Pinup::VERSION
  s.author                = 'Keith Smiley'
  s.email                 = 'keithbsmiley@gmail.com'
  s.homepage              = 'http://keith.so/'
  s.required_ruby_version = '>= 1.9.3'
  s.summary               = 'Digest your Pinboard bookmarks in bulk'
  s.description           = 'Allows you to open and delete your Pinboard bookmarks in bulk'
  s.license               = 'MIT'

  s.files                 = `git ls-files`.split($/)
  s.executables           = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files            = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths         = ['lib']

  s.add_dependency('colored', '~> 1.2')
  s.add_dependency('netrc', '~> 0.7.7')
  s.add_dependency('launchy', '~> 2.3.0')
  s.add_development_dependency('rake')
  s.add_development_dependency('coveralls')
  s.add_development_dependency('rspec', '~> 2.13.0')
  s.add_runtime_dependency('gli','2.5.6')
end
