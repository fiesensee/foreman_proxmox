# $:.push File.expand_path("../lib", __FILE__)

# # Maintain your gem's version:
# require "foreman_proxmox/version"

# # Describe your gem and declare its dependencies:
# Gem::Specification.new do |s|
#   s.name        = "foreman_proxmox"
#   s.version     = ForemanProxmox::VERSION
#   s.authors     = ["Felix Isensee"]
#   s.email       = ["f.isensee@gmail.com"]
#   s.homepage    = "TODO"
#   s.summary     = "TODO: Summary of ForemanProxmox."
#   s.description = "TODO: Description of ForemanProxmox."
#   s.license     = "MIT"

#   s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
#   s.test_files = Dir["test/**/*"]

#   s.add_dependency "rails", "~> 4.2.1"

#   s.add_development_dependency "sqlite3"
# end
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
  
  s.add_dependency 'httpclient', '2.6.0.1'
  s.add_dependency 'json'
  
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rdoc'
end
