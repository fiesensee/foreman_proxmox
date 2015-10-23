require 'httpclient'
require 'json'
require 'logger'
module ForemanProxmox
  class Proxmoxserver < ActiveRecord::Base
    has_many :virtualmachines
    
    def initialize
      @client = setup_httpclient
      $LOG= Logger.new("/tmp/proxmox_debug.log")
      $Log.error("Start Here")
    end
    
    def setup_httpclient
      @client= HTTPClient.new
      @client.ssl_config.verify_mode= OpenSSL::SSL::VERIFY_NONE
      $LOG= Logger.new("/tmp/proxmox_debug.log")
      $LOG.error("Created HttpClient")
    end
    
    def authenticate_client
      if @client == nil then setup_httpclient end
      domain= "https://#{self.ip}:8006/"
      url= URI.parse(domain)
      credentials= {:username => "#{self.username}@pam", :password => self.password}
      auth_response= @client.post("https://#{self.ip}:8006/api2/json/access/ticket", credentials)
      $LOG.error(auth_response.body)
      auth= JSON.parse(auth_response.body)
      ticket= auth["data"]["ticket"]
      token= auth["data"]["CSRFPreventionToken"]
      @header= {:CSRFPreventionToken => token}
      $LOG.error("#{ticket} #{token}")
      cookie_ticket= WebAgent::Cookie.new
      cookie_ticket.name= 'PVEAuthCookie'
      cookie_ticket.value= ticket
      cookie_ticket.url= url
      @client.cookie_manager.add(cookie_ticket)
    end
    
    #manage kvms
    def create_ide(vmid, size)
      authenticate_client
      body= { :filename => "vm-#{vmid}-disk-0.qcow2", :format => "qcow2", :size => size, :vmid => vmid}
      testres= @client.post("https://#{self.ip}:8006/api2/json/nodes/proxmox/storage/local/content",body,@header)
      $LOG.error("Body: #{testres.body}")
      $LOG.error("Header: #{testres.header}")
    end
    
    def create_kvm(vmid, sockets, cores ,memory,mac)
      authenticate_client
      body= { :vmid => vmid, :sockets => sockets, :cores => cores, :memory => memory, :net0 => "e1000=#{mac},bridge=vmbr1", :ide0 => "volume=local:#{vmid}/vm-#{vmid}-disk-0.qcow2,media=disk"}
      testres= @client.post("https://#{self.ip}:8006/api2/json/nodes/proxmox/qemu",body,header)
      $LOG.error("Body: #{testres.body}")
      $LOG.error("Header: #{testres.header}")
    end
    
    def edit_kvm(vmid)
    end
    
    def delete_kvm(vmid)
    end
    
    def start_kvm(vmid)
      testres= @client.post("https://#{self.ip}:8006/api2/json/nodes/proxmox/qemu/#{vmid}/status/start",{},header)
      $LOG.error("Body: #{testres.body}")
      $LOG.error("Header: #{testres.header}")
    end
    
    def stop_kvm(vmid)
    end
    
    def reboot_kvm(vmid)
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
