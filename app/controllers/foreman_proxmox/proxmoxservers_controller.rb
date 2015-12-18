module ForemanProxmox
  class ProxmoxserversController < ApplicationController
    
    def index
      @proxmoxservers = Proxmoxserver.order.all
    end
    
    def show
      @proxmox = Proxmoxserver.find(params[:id])
    end
    
      
    def new
      @proxmox = Proxmoxserver.new
    end
    
    def create
      new_proxmox = Proxmoxserver.create(params[:proxmoxserver])
      if(Proxmoxserver.all.size == 1)
        new_proxmox.current = true
        new_proxmox.save
      end
      redirect_to '/proxmox'
    end
    
    # def edit
    #   @proxmox = Proxmoxserver.find(params[:id])
    # end
    
    # def update
    #   proxmox = Proxmoxserver.find(params[:id])
    #   proxmox.update_attributes(params[:proxmoxserver])
    #   proxmox.save
    # end
    
    def destroy
      proxmox = Proxmoxserver.find(params[:id])
      if(proxmox.current == true)
        new_current = Proxmoxserver.all.first
        new_current.current = true
        new_current.save
      end
      proxmox.delete
      redirect_to '/proxmox'
    end
    
    def setcurrent
      oldcurrent = Proxmoxserver.all
      oldcurrent.each do |old|
        old.current = false
        old.save
      end
      newcurrent = Proxmoxserver.find(params[:id])
      newcurrent.current= true
      newcurrent.save
      redirect_to :back
    end
    
  end
end
