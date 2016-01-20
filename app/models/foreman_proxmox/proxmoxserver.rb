require 'httpclient'
require 'json'
require 'logger'
module ForemanProxmox
  class Proxmoxserver < ActiveRecord::Base
    $LOG= Logger.new("/tmp/proxmox_debug.log")
    
    def setup_httpclient
      @client= HTTPClient.new
      @client.ssl_config.verify_mode= OpenSSL::SSL::VERIFY_NONE
      $LOG.error("Created HttpClient")
    end
    
    def check_ip_connectivity
      $LOG.error("checking connect")
      if @client == nil then setup_httpclient end
        
      code_response = @client.get("https://#{self.ip}:8006/api2/json/access/ticket")
      #$LOG.error(code_response)
      if code_response.code != 200 then
        $LOG.error("connection fail")
        flash[:error] = "Proxmoxserver seems down, try again or change Server"
        return false
      else
        $LOG.error("connection there")
        return true
      end
    end
    
    def authenticate_client
      $LOG.error("authenticating")
      domain= "https://#{self.ip}:8006/"
      url= URI.parse(domain)
      credentials= {:username => "#{self.username}@pam", :password => self.password}
      auth_response= @client.post("https://#{self.ip}:8006/api2/json/access/ticket", credentials)
      #$LOG.error(auth_response.body)
      auth= JSON.parse(auth_response.body)
      ticket= auth["data"]["ticket"]
      token= auth["data"]["CSRFPreventionToken"]
      @header= {:CSRFPreventionToken => token}
      #$LOG.error("#{ticket} #{token}")
      cookie_ticket= WebAgent::Cookie.new('PVEAuthCookie', ticket, :url => url)
      #cookie_ticket.name= 'PVEAuthCookie'
      #cookie_ticket.value= ticket
      #cookie_ticket.url= url
      @client.cookie_manager.add(cookie_ticket)
      $LOG.error("authenticated")
    end
    
    def get_first_node_in_cluster
      if !check_ip_connectivity then
        return nil
      end
      authenticate_client
      nodes_response = @client.get("https://#{self.ip}:8006/api2/json/nodes")
      nodes = JSON.parse(nodes_response.body)
      return nodes["data"][0]["node"]
    end
    
    def find_node_for_vmid(vm)
      authenticate_client
      nodes_response = @client.get("https://#{self.ip}:8006/api2/json/nodes")
      nodes = JSON.parse(nodes_response.body)
      current_node_id = 0
      current_node = nodes["data"][current_node_id]
      while current_node != nil
        node_name = nodes["data"][current_node_id]["node"]
        current_vm_id = 0
        vms_response = @client.get("https://#{self.ip}:8006/api2/json/nodes/#{node_name}/qemu")
        vms = JSON.parse(vms_response.body)
        current_vm = vms["data"][current_vm_id]
        while current_vm != nil do
          if vms["data"][current_vm_id]["vmid"] == vm.vmid
            vm.node = node_name
            vm.save
          end
          current_vm_id+=1
          current_vm = vms["data"][current_vm_id]
        end
        current_node_id+=1
        current_node = nodes["data"][current_node_id]
      end
    end
    
    def get_vm_attributes(host)
      data = {}
      $LOG.error("VmAttr")	
      host.params.each do |param|
	      #$LOG.error(param)
        if(param[0].include? "vm.")
	        #$LOG.error(param)
          parameter = param[0].split(".")
	        #$LOG.error(parameter[1])
          data = data.merge({parameter[1] => param[1]})
        end
      end
      $LOG.error(data)
      return data
    end
    
    def get_next_free_vmid
      $LOG= Logger.new("/tmp/proxmox_debug.log")
      #$LOG.error("start here")
      authenticate_client
      nodes_response = @client.get("https://#{self.ip}:8006/api2/json/nodes")
      nodes = JSON.parse(nodes_response.body)
      #$LOG.error(nodes)
      current_node_id = 0
      highest_vmid = 0
      current_node = nodes["data"][current_node_id]
      #$LOG.error(current_node)
      while current_node != nil 
        node_name = nodes["data"][current_node_id]["node"]
        #$LOG.error(node_name)
        current_vm_id = 0
        vms_response = @client.get("https://#{self.ip}:8006/api2/json/nodes/#{node_name}/qemu")
        vms = JSON.parse(vms_response.body)
        #$LOG.error(vms)
        current_vm = vms["data"][current_vm_id]
        while current_vm != nil do
          if vms["data"][current_vm_id]["vmid"].to_i > highest_vmid 
            highest_vmid = vms["data"][current_vm_id]["vmid"].to_i
            #$LOG.error(highest_vmid)
          end
          current_vm_id+=1
          current_vm = vms["data"][current_vm_id]
        end 
        current_node_id+=1
        current_node = nodes["data"][current_node_id]
      end
      #$LOG.error(highest_vmid+1).to_s
      return highest_vmid+1
    end
    
    def validateNode(node)
      nodes_response = @client.get("https://#{self.ip}:8006/api2/json/nodes")
      nodes = JSON.parse(nodes_response.body)
      i = 0
      while node != null
        if nodes[data][i][node] == vm.node
          return true
        end
        i += 1
      end
      return false
    end
    
    def clientpost(url, body)
      authenticate_client
      response = @client.post(url,body,@header)
      $LOG.error(response.status)
      $LOG.error("Body: #{response.body}")
      $LOG.error("Header: #{response.header}")
      return response
    end
    
    #manage kvms
    def create_ide(vm)
      if !check_ip_connectivity then
        return nil
      end
      body= { :filename => "vm-#{vm.vmid}-disk-0.raw", :format => "raw", :size => vm.size, :vmid => vm.vmid}
      response = clientpost("https://#{self.ip}:8006/api2/json/nodes/#{vm.node}/storage/#{self.storage}/content",body)
      if response.status == 200
        return true
      else
        if error["errors"] == nil
          return response.header.reason_phrase
        else
          return error["errors"]
        end
      end
    end
    
    def create_kvm(vm,host)
      if !check_ip_connectivity then
        return nil
      end
      body = { :vmid => vm.vmid, :name => vm.name, :sockets => vm.sockets, :cores => vm.cores, :memory => vm.memory, :net0 => "e1000=#{vm.mac},bridge=#{self.bridge}"}
      if self.storagetype == 'lvm'
        body = body.merge(:ide0 => "volume=#{self.storage}:vm-#{vm.vmid}-disk-0.raw,media=disk")
      else
        body = body.merge(:ide0 => "volume=#{self.storage}:#{vm.vmid}/vm-#{vm.vmid}-disk-0.raw,media=disk")
      end
      body = body.merge(get_vm_attributes(host))
      $LOG.error(body)
      response = clientpost("https://#{self.ip}:8006/api2/json/nodes/#{vm.node}/qemu",body)
      if response.status == 200
        return true
      else
        error = JSON.parse(response.body)
        if error["errors"] == nil
          return response.header.reason_phrase
        else
          return error["errors"]
        end
      end
    end
    
    def edit_kvm(vmid)
    end
    
    def get_vm_status(vm)
      status_response = clientpost("https://#{self.ip}:8006/api2/json/nodes/#{vm.node}/qemu/#{vm.vmid}/status/current",{})
      status_body = JSON.parse(status_response.body)
      return status_body["data"]["status"]
    end
    
    def delete_kvm(vm)
      if !check_ip_connectivity then
        return nil
      end
      authenticate_client
      find_node_for_vmid(vm.vmid)
      @client.delete("https://#{self.ip}:8006/api2/json/nodes/#{vm.node}/qemu/#{vm.vmid}",{},@header)
    end
    
    def start_kvm(vm)
      if !check_ip_connectivity then
        return nil
      end
      find_node_for_vmid(vm.vmid)
      clientpost("https://#{self.ip}:8006/api2/json/nodes/#{vm.node}/qemu/#{vm.vmid}/status/start",{})
    end
    
    def stop_kvm(vm)
      if !check_ip_connectivity then
        return nil
      end
      find_node_for_vmid(vm.vmid)
      clientpost("https://#{self.ip}:8006/api2/json/nodes/#{vm.node}/qemu/#{vm.vmid}/status/stop",{})
    end
    
    def reboot_kvm(vm)
      if !check_ip_connectivity then
        return nil
      end
      find_node_for_vmid(vmid)
      clientpost("https://#{self.ip}:8006/api2/json/nodes/#{vm.node}/qemu/#{vm.vmid}/status/reset",{})
    end
    
  end
end
