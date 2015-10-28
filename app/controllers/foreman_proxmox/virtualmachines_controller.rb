module ForemanProxmox
  class VirtualmachinesController < ApplicationController
    
    def create_vm
      proxmoxserver = Proxmoxserver.last
      host = Host.find(params[:id])
      new_vm = Virtualmachine.create(
        vmid: host.params['vmid'],
        sockets: host.params['sockets'],
        cores: host.params['cores'],
        memory: host.params['memory'],
        size: host.params['size'],
        mac: host.mac,
        proxmoxserver_id: proxmoxserver.id
      )
      new_vm.create
      new_vm.start
      redirect_to :back
    end
    
    def start_vm
      host = Host.find(params[:id])
      vm = Virtualmachine.find(host.params['vmid'])
      vm.start
      redirect_to :back
    end
    
    def stop_vm
      host = Host.find(params[:id])
      vm = Virtualmachine.find(host.params['vmid'])
      vm.stop
      redirect_to :back
    end
    
    def reboot_vm
      host = Host.find(params[:id])
      vm = Virtualmachine.find(host.params['vmid'])
      vm.reboot
      redirect_to :back
    end
    
    def delete_vm
      host = Host.find(params[:id])
      vm = Virtualmachine.find(host.params['vmid'])
      vm.delete
      redirect_to :back
    end
    
  end
end
