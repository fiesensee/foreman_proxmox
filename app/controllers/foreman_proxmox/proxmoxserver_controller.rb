module ForemanProxmox
  class ProxmoxserverController < ApplicationController
      
    def new
    end
    
    def create
    end
    
    def edit
    end
    
    def update
    end
    
    def show
      @proxmox = Proxmoxserver.last
    end
    
    def start_all_vms
      redirect_to :back
    end
    
    def stop_all_vms
    end
    
    def reboot_node
    end
    
    def shutdown_node
    end
    
  end
end
