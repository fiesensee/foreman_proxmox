module ForemanProxmox
  class Virtualmachine < ActiveRecord::Base
    belongs_to :host
    has_many :harddisks, :dependent => :destroy
    
    def create_harddisk
      proxmoxserver = Proxmoxserver.where("current = 'true'").first
      proxmoxserver.create_ide(self.vmid,self.size)
    end
    
    def create_virtualmachine
      proxmoxserver = Proxmoxserver.where("current = 'true'").first
      proxmoxserver.create_kvm(self.vmid,self.sockets,self.cores,self.memory,self.mac)
    end
    
    def start
      proxmoxserver = Proxmoxserver.where("current = 'true'").first
      proxmoxserver.start_kvm(self.vmid)
    end
    
    def stop
      proxmoxserver = Proxmoxserver.where("current = 'true'").first
      proxmoxserver.stop_kvm(self.vmid)
    end
    
    def reboot
      proxmoxserver = Proxmoxserver.where("current = 'true'").first
      proxmoxserver.reboot_kvm(self.vmid)
    end
    
    def delete_virtualmachine
      proxmoxserver = Proxmoxserver.where("current = 'true'").first
      self.stop
      proxmoxserver.delete_kvm(self.vmid)
      self.destroy
    end
    
    def get_free_vmid
      proxmoxserver = Proxmoxserver.where("current = 'true'").first
      self.vmid = proxmoxserver.get_next_free_vmid
    end
  end
end
