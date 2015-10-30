module ForemanProxmox
  class VirtualmachinesController < ApplicationController
    
    def create_vm
      host = Host.find(params[:id])
      new_vm = Virtualmachine.new
      
      if host.params['proxmox_id'] == nil then
        proxmoxserver = Proxmoxserver.where("current = 'true'").first
      else
        proxmoxserver = Proxmoxserver.find(host.params['proxmox_id'])
      end
      
      if host.params['vmid'] == nil then
        # new_vm.vmid = proxmoxserver.get_next_free_vmid
        flash[:notice] = new_vm.get_free_vmid
      else
        new_vm.vmid = host.params['vmid']
      end
      
      new_vm.sockets = host.params['sockets']
      new_vm.cores = host.params['cores']
      new_vm.memory = host.params['memory']
      new_vm.size = host.params['size']
      new_vm.mac = host.mac
      new_vm.proxmoxserver_id = proxmoxserver.id
      
      # if new_vm.save then
      #   flash[:notice] = "VM saved in DB"
      # else
      #   flash[:error] = _('Fail')
      
      # end
      # new_vm.create_qemu
      # new_vm.start
      
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
