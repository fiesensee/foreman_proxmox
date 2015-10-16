module ForemanProxmox
  class ConnectionController < ApplicationController
    
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
      @connection = Connection.new
    end
    
    def update
    end
    
    def edit
    end
  end
end
