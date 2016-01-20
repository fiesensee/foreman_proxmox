require 'logger'
module ForemanProxmox
  class Virtualmachine < ActiveRecord::Base
    belongs_to :host
    
    def create_harddisk
      proxmoxserver = Proxmoxserver.where(:current => true).first
      create_response = proxmoxserver.create_ide(self)
      if create_response  == true
        return true
      else
        self.errormsg = create_response
        self.save
        return false
      end
    end
    
    def create_virtualmachine(host)
      proxmoxserver = Proxmoxserver.where(:current => true).first
      create_response = proxmoxserver.create_kvm(self,host)
      if create_response  == true
        return true
      else
        self.errormsg = create_response
        self.save
        return false
      end
    end
    
    def start
      proxmoxserver = Proxmoxserver.where(:current => true).first
      proxmoxserver.start_kvm(self)
    end
    
    def stop
      proxmoxserver = Proxmoxserver.where(:current => true).first
      proxmoxserver.stop_kvm(self)
    end
    
    def reboot
      proxmoxserver = Proxmoxserver.where(:current => true).first
      proxmoxserver.reboot_kvm(self)
    end
    
    def delete_virtualmachine
      proxmoxserver = Proxmoxserver.where(:current => true).first
      self.stop
      proxmoxserver.delete_kvm(self)
      self.destroy
    end
    
    def get_free_vmid
      proxmoxserver = Proxmoxserver.where(:current => true).first
      self.vmid = proxmoxserver.get_next_free_vmid
    end
    
    def get_status
      $LOG = Logger.new("/tmp/status.log")
      $LOG.error("getting status")
      proxmoxserver = Proxmoxserver.where(:current => true).first
      if self.status == "Error"
        $LOG.error("error: #{self.errormsg}")
        if self.errormsg != nil
          return self.errormsg
        else
          return "Check error log"
        end
      else
        $LOG.error("nominal")
        self.status = proxmoxserver.get_vm_status(self)
        self.save
        return self.status
      end
    end
    
    def setNode(node)
      proxmoxserver = Proxmoxserver.where(:current => true).first
      if node == nil
        self.node = proxmoxserver.get_first_node_in_cluster
      elseif !proxmoxserver.validateNode(node)
        return false
      else
        self.node = node
      end
      self.save
      return true
    end
  end
end
