module ForemanProxmox
  class Virtualmachine < ActiveRecord::Base
    belongs_to :host
    
    def create_harddisk
      proxmoxserver = Proxmoxserver.where(:current => true).first
      create_response = proxmoxserver.create_ide(self.vmid,self.size)
      if create_response  == true
        return true
      else
        self.errormsg = create_response
        return false
      end
    end
    
    def create_virtualmachine(host)
      proxmoxserver = Proxmoxserver.where(:current => true).first
      create_response = proxmoxserver.create_kvm(self.vmid,self.name,self.sockets,self.cores,self.memory,self.mac,host)
      if create_response  == true
        return true
      else
        self.errormsg = create_response
        return false
      end
    end
    
    def start
      proxmoxserver = Proxmoxserver.where(:current => true).first
      proxmoxserver.start_kvm(self.vmid)
    end
    
    def stop
      proxmoxserver = Proxmoxserver.where(:current => true).first
      proxmoxserver.stop_kvm(self.vmid)
    end
    
    def reboot
      proxmoxserver = Proxmoxserver.where(:current => true).first
      proxmoxserver.reboot_kvm(self.vmid)
    end
    
    def delete_virtualmachine
      proxmoxserver = Proxmoxserver.where(:current => true).first
      self.stop
      proxmoxserver.delete_kvm(self.vmid)
      self.destroy
    end
    
    def get_free_vmid
      proxmoxserver = Proxmoxserver.where(:current => true).first
      self.vmid = proxmoxserver.get_next_free_vmid
    end
    
    def get_status
      proxmoxserver = Proxmoxserver.where(:current => true).first
      if self.status = "Error"
          return self.errormsg
        else
          self.status = proxmoxserver.get_vm_status(self.vmid)
        return self.status
      end
    end
  end
end
