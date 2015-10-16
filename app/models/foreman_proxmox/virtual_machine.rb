require 'http-client'
module ForemanProxmox
  class VirtualMachine < ActiveRecord::Base
    
    
    def initialize(host, connection)
      self.vmid = host.params["vmid"]
      self.sockets = host.params["sockets"]
      self.cores = host.params["cores"]
      self.memory = host.params["memory"]
      self.size = host.params["size"]
      self.mac = host.mac
      self.connection = connection
      @httpclient = setup_httpclient
    end
    
    def setup_httpclient
      httpclient = HTTPClient.new
      httpclient.ssl_config.verify_mode= OpenSSL::SSL::VERIFY_NONE
      return httpclient
    end
    
    def authenticate_and_get_token
      credentials = {:username => "#{self.connection.username}@pam", :password => self.connection.password}
      auth_response = @httpclient.post("https://#{self.connection.ip}:8006/api2/json/access/ticket", credentials)

      $LOG.error(auth_response.body)
      
      auth = JSON.parse(auth_response.body)
      ticket = auth["data"]["ticket"]
      token = auth["data"]["CSRFPreventionToken"]
      
      $LOG.error("#{ticket} #{token}")
      
      domain = "https://#{self.connection.ip}:8006/"
      url = URI.parse(domain)
      
      $LOG.error(url)      
      
      cookie_ticket = WebAgent::Cookie.new
      cookie_ticket.name = 'PVEAuthCookie'
      cookie_ticket.value = ticket
      cookie_ticket.url = url
      @httpclient.cookie_manager.add(cookie_ticket)
      
      return token
      
    end
    def create
      
      $LOG = Logger.new("/tmp/proxmox_debug.log")
      
      token = self.authenticate_and_get_token
      
      #allocate disk for vm 
      header= {:CSRFPreventionToken => token}
      body= { :filename => "vm-#{self.vmid}-disk-0.qcow2", :format => "qcow2", :size => self.size, :vmid => self.vmid}
      testres= @httpclient.post("https://#{self.connection.ip}:8006/api2/json/nodes/proxmox/storage/local/content",body,header)
      
      $LOG.error("Body: #{testres.body}")
      $LOG.error("Header: #{testres.header}")
      
      #create vm
      body= { :vmid => self.vmid, :sockets => self.sockets, :cores => self.cores, :memory => self.memory, :net0 => "e1000=#{self.mac},bridge=vmbr1", :ide0 => "volume=local:#{self.vmid}/vm-#{self.vmid}-disk-0.qcow2,media=disk"}
      testres= @httpclient.post("https://#{self.connection.ip}:8006/api2/json/nodes/proxmox/qemu",body,header)
      
      $LOG.error("Body: #{testres.body}")
      $LOG.error("Header: #{testres.header}")
      
      #start vm
      self.start
      

    end
    
    def start
      @httpclient.post("https://#{self.connection.ip}:8006/api2/json/nodes/proxmox/qemu/#{self.vmid}/status/start",body,header)
      $LOG.error("Body: #{testres.body}")
      $LOG.error("Header: #{testres.header}")
    end
    
    def stop
    end
    
    def delete
    end
    
    
  end
end
