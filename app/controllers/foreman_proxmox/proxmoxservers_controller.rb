module ForemanProxmox
  class ProxmoxserversController < ApplicationController
    
    def index
      @proxmoxservers = Proxmoxserver.all
    end
    
    def show
      @proxmox = Proxmoxserver.find(params[:id])
    end
    
      
    def new
      @proxmox = Proxmoxserver.new
    end
    
    def create
      Proxmoxserver.create(params[:proxmoxserver])
      redirect_to '/proxmox'
    end
    
    def edit
      @proxmox = Proxmoxserver.find(params[:id])
    end
    
    def update
      server = Proxmoxserver.find(params[:id])
      server.ip = params[:id]
      server.username = params[:username]
      server.password = params[:password]
      server.save
      redirect_to '/proxmox'
    end
    
    def destroy
      Proxmoxserver.find(params[:id]).delete
    end
    
    def setcurrent
      oldcurrent = Proxmoxserver.where("current = 'true'")
      flash[:notice] = oldcurrent.first.id
      oldcurrent.each do |old|
        old.current = false
        old.save
      end
      newcurrent = Proxmoxserver.find(params[:id])
      newcurrent.current= true
      newcurrent.save
      redirect_to :back
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
