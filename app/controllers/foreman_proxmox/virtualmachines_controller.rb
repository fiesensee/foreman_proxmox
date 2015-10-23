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
      new_vm.mac = host.mac
      new_vm.proxmoxserver_id = proxmoxserver.id
      new_vm.create
      new_vm.start
      redirect_to :back
    end
    
    def start_vm
      host = Host.find(params[:id])
      vm = Virtualmachine.find_by vmid: host.params["vmid"]
      vm.start
      redirect_to :back
    end
    
    def stop_vm
      host = Host.find(params[:id])
      vm = Virtualmachine.find_by vmid: host.params["vmid"]
      vm.stop
      redirect_to :back
    end
    
    def reboot_vm
      host = Host.find(params[:id])
      vm = Virtualmachine.find_by vmid: host.params["vmid"]
      vm.reboot
      redirect_to :back
    end
    
    def delete_vm
      host = Host.find(params[:id])
      vm = Virtualmachine.find_by vmid: host.params["vmid"]
      vm.delete
      redirect_to :back
    end
    
  end
end
