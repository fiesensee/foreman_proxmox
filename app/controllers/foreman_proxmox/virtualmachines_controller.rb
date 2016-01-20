require 'logger'
module ForemanProxmox
  class VirtualmachinesController < ApplicationController
    
    def start_vm
      vm = Virtualmachine.where("host_id = '#{params[:id]}'").first
      vm.start
      redirect_to :back
    end
    
    def stop_vm
      vm = Virtualmachine.where("host_id = '#{params[:id]}'").first
      vm.stop
      redirect_to :back
    end
    
    def reboot_vm
      vm = Virtualmachine.where("host_id = '#{params[:id]}'").first
      vm.reboot
      redirect_to :back
    end
    
    def delete_vm
      vm = Virtualmachine.where("host_id = '#{params[:id]}'").first
      vm.delete_virtualmachine
      redirect_to :back
    end
    
    
    
    def show
      @vm = Virtualmachine.where("host_id = '#{params[:id]}'").first
    end
    
  end
end
