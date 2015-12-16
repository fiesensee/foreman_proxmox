#A Foreman plugin for Proxmoxsupport

Offers basic support for creating kvm vms in Proxmox via Foreman.

##Installation

After successfully installing Foreman clone this git repo and create a File 'Gemfile.local.rb' in your ../foreman/bundler.d directory. In this file you write "gem 'foreman_proxmox', :path => '/path/to/plugin'".                            
Then go to .../foreman_proxmox/MainAppEdits and execute the override.sh.
Then run (from your foreman dir) bundle install and update, foreman-rake db:migrate and restart your rails app (touch tmp/restart.txt).

##Configuration

First go to your ForemanProxmox site, located in the Hosts menu. There you enter the information for one or multiple Proxmoxservers. 
Now you choose one server to be your current provisioning server, this is mandatory.

##VM Creation

For the creation of a vm a couple of properties are needed, which you will set through foreman parameter-system. 
These are necessary:
  - sockets
  - cores
  - memory
  - size (*size*G)
  
These are optional:
  - vmid (is automatically the next highest vmid from all your vms, if let empty)
  - name (if empty name will be shortname of your foremanhost)
  
You can also assign other proxmoxprovided properties by assigning parameters like this:

  name = vm.*property*
  
  value = *propertyvalue*
  
  e.g.
  
  vm.pool              proxmox
  
These properties are not sanatized.

After completing this step you just have to use foremans normal host creation process and a new vm should appear in your proxmox server. 
