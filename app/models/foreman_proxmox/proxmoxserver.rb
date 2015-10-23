require 'httpclient'
module ForemanProxmox
  class Proxmoxserver < ActiveRecord::Base
    has_many :virtualmachines
    
    def initialize
      @client = setup_httpclient
      $LOG= Logger.new("/tmp/proxmox_debug.log")
    end
    
    def setup_httpclient
      client= HTTPClient.new
      client.ssl_config.verify_mode= OpenSSL::SSL::VERIFY_NONE
      return client
    end
    
    def authenticate_client
      domain= "https://#{self.ip}:8006/"
      url= URI.parse(domain)
      credentials= {:username => "#{self.username}@pam", :password => self.password}
      auth_response= @client.post("https://#{self.ip}:8006/api2/json/access/ticket", credentials)
      $LOG.error(auth_response.body)
      auth= JSON.parse(auth_response.body)
      ticket= auth["data"]["ticket"]
      token= auth["data"]["CSRFPreventionToken"]
      flash[:notice] = auth_response.status
      $LOG.error("#{ticket} #{token}")
      cookie_ticket= WebAgent::Cookie.new
      cookie_ticket.name= 'PVEAuthCookie'
      cookie_ticket.value= ticket
      cookie_ticket.url= url
      @client.cookie_manager.add(cookie_ticket)
    end
    
    #manage kvms
    def create_ide
      authenticate_client
    end
    
    def create_kvm
    end
    
    def edit_kvm
    end
    
    def delete_kvm
    end
    
    def start_kvm
    end
    
    def stop_kvm
    end
    
    def reboot_kvm
    end

    
    #manage node
    def reboot
    end
    
    def shutdown
    end
    
    def start_all_vms
    end
    
    def stop_all_vms
    end
    
  end
end
