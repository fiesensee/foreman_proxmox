require 'httpclient'
module ForemanProxmox
  class Proxmoxserver < ActiveRecord::Base
    has_many :virtualmachines
    
    def initialize
    end
    
    #manage kvms
    def create_ide
      redirect_to :back
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
      redirect_to :back
    end
    
    def shutdown
      redirect_to :back
    end
    
    def start_all_vms
      redirect_to :back
    end
    
    def stop_all_vms
      redirect_to :back
    end
    
  end
end
