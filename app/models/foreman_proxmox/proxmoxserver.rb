require 'httpclient'
require 'json'
require 'logger'
module ForemanProxmox
  class Proxmoxserver < ActiveRecord::Base
    has_many :virtualmachines
    
    def setup_httpclient
      @client= HTTPClient.new
      @client.ssl_config.verify_mode= OpenSSL::SSL::VERIFY_NONE
      @node = get_first_node_in_cluster
      $LOG= Logger.new("/tmp/proxmox_debug.log")
      $LOG.error("Created HttpClient")
    end
    
    def get_first_node_in_cluster
      if !check_ip_connectivity then
        flash[:error] = "Proxmoxserver seems down, try again"
        return nil
      end
      authenticate_client
      nodes_response = @client.get("https://#{self.ip}:8006/api2/json/nodes")
      nodes = JSON.parse(nodes_response.body)
      return nodes["data"][0]["node"]
    end
    
    def check_ip_connectivity
      $LOG.error("checking connect")
      if @client == nil then setup_httpclient end
      code_response = @client.get("https://#{self.ip}:8006/api2/json/access/ticket")
      $LOG.error(code_response)
      if code_response.code != 200 then
        # self = Proxmoxserver.find(self.id + 1)
        # self.save
        $LOG.error("connection fail")
        return false
      else
        $LOG.error("connection there")
        return true
      end
    end
    
    def find_node_for_vmid(vmid)
      authenticate_client
      nodes_response = @client.get("https://#{self.ip}:8006/api2/json/nodes")
      nodes = JSON.parse(nodes_response.body)
      current_node_id = 0
      current_node = nodes["data"][current_node]
      while current_node != nil
        node_name = nodes["data"][current_node_id]["node"]
        current_vm_id = 0
        vms_response = @client.get("https://#{self.ip}:8006/api2/json/nodes/#{node_name}/qemu")
        vms = JSON.parse(vms_response.body)
        current_vm = vms["data"][current_vm_id]
        while cur_vm != nil do
          if vms["data"][current_vm_id]["vmid"] == vmid
            @node = node_name
          end
          current_vm_id+=1
          current_vm = vms["data"][current_vm_id]
        end
        current_node_id+=1
        current_node = nodes["data"][current_node_id]
      end
    end
    
    def get_next_free_vmid
      $LOG= Logger.new("/tmp/proxmox_debug.log")
      $LOG.error("start here")
      authenticate_client
      nodes_response = @client.get("https://#{self.ip}:8006/api2/json/nodes")
      nodes = JSON.parse(nodes_response.body)
      $LOG.error = nodes
      current_node_id = 0
      highest_vmid = 0
      current_node = nodes["data"][current_node_id]
      while current_node != nil 
        node_name = nodes["data"][current_node]["node"]
        current_vm_id = 0
        vms_response = @client.get("https://#{self.ip}:8006/api2/json/nodes/#{node_name}/qemu")
        vms = JSON.parse(vms_response)
        $LOG.error = vms
        current_vm = vms["data"][current_vm_id]
        while current_vm != nil do
          if vms["data"][current_vm_id]["vmid"].to_i > highest_vmid 
            highest_vmid = vms["data"][current_vm_id]["vmid"].to_i
          end
          current_vm_id+=1
          current_vm = vms["data"][current_vm_id]
        end 
        current_node_id+=1
        current_node = nodes["data"][current_node_id]
      end
      $LOG.error(highest_vmid+1).to_s
      return highest_vmid+1
    end
    
    def authenticate_client
      if !check_ip_connectivity then
        flash[:error] = "Proxmoxserver seems down, try again"
        return nil
      end
      $LOG.error("authenticating")
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
      $LOG.error("authenticated")
    end
    
    #manage kvms
    def create_ide(vmid, size)
      if !check_ip_connectivity then
        flash[:error] = "Proxmoxserver seems down, try again"
        return nil
      end
      authenticate_client
      body= { :filename => "vm-#{vmid}-disk-0.qcow2", :format => "qcow2", :size => size, :vmid => vmid}
      testres= @client.post("https://#{self.ip}:8006/api2/json/nodes/#{@node}/storage/local/content",body,@header)
      $LOG.error("Body: #{testres.body}")
      $LOG.error("Header: #{testres.header}")
    end
    
    def create_kvm(vmid, sockets, cores ,memory,mac)
      if !check_ip_connectivity then
        flash[:error] = "Proxmoxserver seems down, try again"
        return nil
      end
      authenticate_client
      body= { :vmid => vmid, :sockets => sockets, :cores => cores, :memory => memory, :net0 => "e1000=#{mac},bridge=vmbr1", :ide0 => "volume=local:#{vmid}/vm-#{vmid}-disk-0.qcow2,media=disk"}
      testres= @client.post("https://#{self.ip}:8006/api2/json/nodes/#{@node}/qemu",body,@header)
      $LOG.error("Body: #{testres.body}")
      $LOG.error("Header: #{testres.header}")
    end
    
    def edit_kvm(vmid)
    end
    
    def delete_kvm(vmid)
      if !check_ip_connectivity then
        flash[:error] = "Proxmoxserver seems down, try again"
        return nil
      end
      find_node_for_vmid(vmid)
      testres= @client.delete("https://#{self.ip}:8006/api2/json/nodes/proxmox/qemu/#{vmid}",{},@header)
      $LOG.error("Body: #{testres.body}")
      $LOG.error("Header: #{testres.header}")
    end
    
    def start_kvm(vmid)
      if !check_ip_connectivity then
        flash[:error] = "Proxmoxserver seems down, try again"
        return nil
      end
      find_node_for_vmid(vmid)
      testres= @client.post("https://#{self.ip}:8006/api2/json/nodes/proxmox/qemu/#{vmid}/status/start",{},@header)
      $LOG.error("Body: #{testres.body}")
      $LOG.error("Header: #{testres.header}")
    end
    
    def stop_kvm(vmid)
      if !check_ip_connectivity then
        flash[:error] = "Proxmoxserver seems down, try again"
        return nil
      end
      find_node_for_vmid(vmid)
      testres= @client.post("https://#{self.ip}:8006/api2/json/nodes/proxmox/qemu/#{vmid}/status/stop",{},@header)
      $LOG.error("Body: #{testres.body}")
      $LOG.error("Header: #{testres.header}")
    end
    
    def reboot_kvm(vmid)
      if !check_ip_connectivity then
        flash[:error] = "Proxmoxserver seems down, try again"
        return nil
      end
      find_node_for_vmid(vmid)
      testres= @client.post("https://#{self.ip}:8006/api2/json/nodes/proxmox/qemu/#{vmid}/status/reset",{},@header)
      $LOG.error("Body: #{testres.body}")
      $LOG.error("Header: #{testres.header}")
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
