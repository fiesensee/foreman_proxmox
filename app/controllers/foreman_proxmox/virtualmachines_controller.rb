module ForemanProxmox
  class VirtualmachinesController < ApplicationController
    
    def create_vm
      proxmoxserver = Proxmoxserver.last
      host = Host.find(params[:id])
      new_vm = Virtualmachine.new
      new_vm.vmid = host.params['vmid']
      new_vm.sockets = host.params['sockets']
      new_vm.cores = host.params['cores']
      new_vm.memory = host.params['memory']
      new_vm.size = host.params['size']
      new_vm.proxmoxserver_id = proxmoxserver.id
      new_vm.safe
      new_vm.create
      new_vm.start
    end
    
    def start_vm
    end
    
    def stop_vm
    end
    
    def reboot_vm
    end
    
    def delete_vm
    end
    
  end
end
