module ForemanProxmox
  module ProxmoxserversHelper
    
    def show_appropriate_connection_button(proxmox)
      if proxmox == nil then
        link_to(_("New"), new_proxmoxserver_path, :class => 'btn')
      else
        link_to(_("Edit"), edit_proxmoxserver_path, :class => 'btn')
      end
    end
    

    
    def show_node_controlls(proxmox)
      [ link_to(_("Start all VMs"), startall_path, :class => 'btn'),
        link_to(_("Stop all VMs"), stopall_path, :class => 'btn'),
        link_to(_("Reboot"), reboot_path, :class => 'btn'),
        link_to(_("Shutdown"), shutdown_path, :class => 'btn')
      ].compact
    end
    
    # def set_options(options={})
    #   ForemanProxmox::Engine.routes.url_for(options.merge(:only_path => true, :controller => 'proxmoxserver'))
    # end
  end
end
