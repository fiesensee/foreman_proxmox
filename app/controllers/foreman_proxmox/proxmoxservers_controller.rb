module ForemanProxmox
  class ProxmoxserversController < ApplicationController
      
    def new
      @proxmox = Proxmoxserver.new
    end
    
    def create
      @proxmox = Proxmoxserver.create(params[:proxmoxserver])
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
      redirect_to :back
    end
    
    def reboot_node
      redirect_to :back
    end
    
    def shutdown_node
      redirect_to :back
    end
    
  end
end
