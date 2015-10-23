module ForemanProxmox
  class Virtualmachine < ActiveRecord::Base
    belongs_to :proxmoxserver
    
    
    def create
      proxmoxserver = Proxmoxserver.find(self.proxmoxserver_id)
      proxmoxserver.create_ide(self.vmid,self.size)
      proxmoxserver.create_kvm(self.vmid,self.sockets,self.cores,self.memory)
    end
    
    def start
      proxmoxserver = Proxmoxserver.find(self.proxmoxserver_id)
      proxmoxserver.start_kvm(self.vmid)
    end
    
    def stop
      proxmoxserver = Proxmoxserver.find(self.proxmoxserver_id)
      proxmoxserver.stop_kvm(self.vmid)
    end
    
    def reboot
      proxmoxserver = Proxmoxserver.find(self.proxmoxserver_id)
      proxmoxserver.reboot_kvm(self.vmid)
    end
    
    def delete
      proxmoxserver = Proxmoxserver.find(self.proxmoxserver_id)
      proxmoxserver.delete_kvm(self.vmid)
    end
  end
end
