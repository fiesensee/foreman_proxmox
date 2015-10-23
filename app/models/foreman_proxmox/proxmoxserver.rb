require 'httpclient'
module ForemanProxmox
  class Proxmoxserver < ActiveRecord::Base
    has_many :virtualmachines
    
    #manage kvms
    def create_ide
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
