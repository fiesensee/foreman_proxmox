module ForemanProxmox
  class ProxmoxConnectionController < ApplicationController
    
    def index
    end
    
    def create 
      if @connection = ProxmoxConnection.create(params[:proxmox_connection])
        flash[:notice] = 'Success'
      else
        flash.now[:alert] = 'Fail'
      end
    end
    
    def new
      @connection = ProxmoxConnection.new
    end
    
    def update
    end
    
    def edit
    end
    
    def show
    end
    
  end
end
