require File.expand_path('../lib/foreman_proxmox/version', __FILE__)
require 'date'

Gem::Specification.new do |s|
  s.name        = 'foreman_proxmox'
  s.version     = ForemanProxmox::VERSION
  s.date        = Date.today.to_s
  s.authors     = ['Felix Isensee']
  s.email       = ['f.isensee@gmail.com']
  s.homepage    = 'http://github.com/fiesensee/foreman_proxmox'
  s.summary     = 'Proxmox support for foreman'
  # also update locale/gemspec.rb
  s.description = 'Adds Proxmox support to foreman'

  s.files = Dir['{app,config,db,lib,locale}/**/*'] + ['LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']
  
  s.add_dependency 'httpclient'
  s.add_dependency 'json'
  
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rdoc'
end