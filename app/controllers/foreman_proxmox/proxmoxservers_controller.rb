module ForemanProxmox
  class ProxmoxserversController < ApplicationController
    
    def index
      @proxmox = Proxmoxserver.new
      @proxmoxservers = Proxmoxserver.all
    end
    
    def show
      @proxmox = Proxmoxserver.find(params[:id])
    end
    
      
    def new
    end
    
    def create
      Proxmoxserver.create(params[:proxmoxserver])
      redirect_to '/proxmox'
    end
    
    def edit
      @proxmox = Proxmoxserver.find(params[:id])
    end
    
    def update
    end
    
    def setcurrent
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
