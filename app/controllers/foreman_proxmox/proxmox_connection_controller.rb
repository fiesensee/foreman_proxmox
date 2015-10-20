module ForemanProxmox
  class ProxmoxConnectionController < ApplicationController
    
    def proxmox
    end
    
    def create 
      if @connection = ProxmoxConnection.create(params[:proxmox_connection])
        flash[:notice] = 'Success'
      else
        flash.now[:alert] = 'Fail'
      end
      redirect_to '/proxmox'
    end
    
    def new
      @connection = ProxmoxConnection.new
    end
    
    def update
    end
    
    def edit
    end
    
    def show
      redirect_to '/proxmox'
    end
    
  end
end
