module ForemanProxmox
  class Virtualmachine < ActiveRecord::Base
    belongs_to :proxmoxserver
    
    
    def initialize
    end
    
    def start
    end
    
    def stop
    end
    
    def reboot 
    end
    
    def delete
    end
  end
end
