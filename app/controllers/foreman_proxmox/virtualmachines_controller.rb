require 'logger'
module ForemanProxmox
  class VirtualmachinesController < ApplicationController
    
    def create_vm
      host = Host.find(params[:id])
      $LOG= Logger.new("/tmp/proxmox_debug.log")
      
      if Virtualmachine.where("host_id = '#{host.id}'").first == nil then
        new_vm = Virtualmachine.new
        
        $LOG.error("creating vm")
        
        if host.params['vmid'] == nil then
          $LOG.error("searching vmid")
          new_vm.get_free_vmid
        else
          new_vm.vmid = host.params['vmid']
        end
        
        $LOG.error(new_vm.vmid)
        new_vm.sockets = host.params['sockets']
        new_vm.cores = host.params['cores']
        new_vm.memory = host.params['memory']
        new_vm.size = host.params['size']
        new_vm.mac = host.mac
        new_vm.host_id = host.id
      
        if new_vm.save then
          flash[:notice] = "VM saved in DB"
        else
          flash[:error] = _('Fail')
        end
      end
      
      new_vm = Virtualmachine.where("host_id = '#{host.id}'").first
      
      new_vm.create_harddisk
      new_vm.create_virtualmachine
      new_vm.start
      
      redirect_to :back
    end
    
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
      vm.delete
      redirect_to :back
    end
    
    
    
    def show
      @vm = Virtualmachine.where("host_id = '#{params[:id]}'").first
    end
    
  end
end
