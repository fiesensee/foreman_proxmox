module ForemanProxmox
  class VmController < ApplicationController
    
    def create_vm
      host_id = params[:id]
      host = Host.find(host_id)
      connection = (ProxmoxConnection.last)
      vm = VirtualMachine.new(host, connection)
      vm.create
      redirect_to :back
    end
    
    def delete_vm(vm)
      vm.stop
      vm.delete
      redirect_to :back
    end
  end
end
