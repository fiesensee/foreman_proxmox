module ForemanProxmox
  module HostsHelperExtensions
    extend ActiveSupport::Concern
    

    included do
      alias_method_chain :host_title_actions, :proxmox
    end

    
    def host_title_actions_with_proxmox(*args)
      title_actions(
          if Virtualmachine.where("host_id = '#{@host.id}'").first != nil
          button_group(
              display_proxmox_if_authorized(_("VM details"), {:controller => 'foreman_proxmox/virtualmachines', :action => 'show', :id => @host.id}, :class => 'btn')
          )
          end,
          if @host.build
            button_group(
              display_proxmox_if_authorized(_("Create VM"), {:controller => 'foreman_proxmox/virtualmachines', :action => 'create_vm', :id => @host.id}, :class => 'btn')
            )
          else
            button_group(
              display_proxmox_if_authorized(_("Delete VM"), {:controller => 'foreman_proxmox/virtualmachines', :action => 'delete_vm', :id => @host.id}, :class => 'btn'),
              select_action_button(_('Power Control'),{},
              display_proxmox_if_authorized(_('Start VM'), {:controller => 'foreman_proxmox/virtualmachines', :action => 'start_vm', :id => @host.id}, :class => 'btn'),
              display_proxmox_if_authorized(_('Stop VM'), {:controller => 'foreman_proxmox/virtualmachines', :action => 'stop_vm', :id => @host.id}, :class => 'btn'),
              display_proxmox_if_authorized(_('Reboot VM'), {:controller => 'foreman_proxmox/virtualmachines', :action => 'reboot_vm', :id => @host.id}, :class => 'btn')
              )
            )
          end
        )
      host_title_actions_without_proxmox(*args)
        title_actions(
          button_group(
            link_to_if_authorized(_("Destroy"), hash_for_host_path(:id => @host).merge(:auth_object => @host, :permission => 'destroy_hosts'),
                                  :class => "btn btn-danger",
                                  :id => "delete-button",
                                  :data => { :message => delete_host_dialog(@host) },
                                  :method => :delete)
          ) 
        )
    end
    
    def display_proxmox_if_authorized(name, options = {}, html_options = {})
      if is_authorized(options)
        link_to(name, proxmox_url(options), html_options)
      else
        ""
      end
    end
    
    def proxmox_url(options)
      ForemanProxmox::Engine.routes.url_for(options.merge(:only_path => true, :script_name => foreman_proxmox_path))
    end
    
    def is_authorized(options)
      User.current.allowed_to?(options)
    end
  end
end
