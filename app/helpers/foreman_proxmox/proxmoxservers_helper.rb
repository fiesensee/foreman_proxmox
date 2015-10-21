module ForemanProxmox
  module ProxmoxserversHelper
    
    def show_appropriate_connection_button(proxmox)
      if proxmox.ip = nil then
        link_to(_("New"), set_options({:action => 'new'}), :class => 'btn')
      else
        link_to(_("Edit"), set_options({:action => 'edit'}), :class => 'btn')
      end
    end
    

    
    def show_node_controlls(proxmox)
      [ link_to(_("Start all VMs"), set_options({:action => 'start_all_vms'}), :class => 'btn'),
        link_to(_("Stop all VMs"), set_options({:action => 'stop_all_vms'}), :class => 'btn'),
        link_to(_("Reboot"), set_options({:action => 'reboot'}), :class => 'btn'),
        link_to(_("Shutdown"), set_options({:action => 'shutdown'}), :class => 'btn')
      ].compact
    end
    
    def set_options(options={})
      ForemanProxmox::Engine.routes.url_for(options.merge(:only_path => true, :script_name => proxmoxservers_path), :controller => 'foreman_proxmox/proxmoxservers')
    end
  end
end
