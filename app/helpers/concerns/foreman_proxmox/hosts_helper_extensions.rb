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
          end,
          button_group(
            link_to_if_authorized(_("Edit"), hash_for_edit_host_path(:id => @host).merge(:auth_object => @host),
                                    :title    => _("Edit your host"), :id => "edit-button"),
            if @host.build
              link_to_if_authorized(_("Cancel build"), hash_for_cancelBuild_host_path(:id => @host).merge(:auth_object => @host, :permission => 'build_hosts'),
                                    :disabled => host.can_be_built?,
                                    :title    => _("Cancel build request for this host"), :id => "cancel-build-button")
            else
              link_to_if_authorized(_("Build"), hash_for_host_path(:id => @host).merge(:auth_object => @host, :permission => 'build_hosts', :anchor => "review_before_build"),
                                    :disabled => !@host.can_be_built?,
                                    :title    => _("Enable rebuild on next host boot"),
                                    :class    => "btn",
                                    :id       => "build-review",
                                    :data     => { :toggle => 'modal',
                                                   :target => '#review_before_build',
                                                   :url    => review_before_build_host_path(:id => @host)
                                    }
            )
            end
          ),
          if @host.compute_resource_id || @host.bmc_available?
          button_group(
              link_to(_("Loading power state ..."), '#', :disabled => true, :id => :loading_power_state)
          )
          end,
          button_group(
          if @host.try(:puppet_proxy)
            link_to_if_authorized(_("Run puppet"), hash_for_puppetrun_host_path(:id => @host).merge(:auth_object => @host, :permission => 'puppetrun_hosts'),
                                  :disabled => !Setting[:puppetrun],
                                  :title    => _("Trigger a puppetrun on a node; requires that puppet run is enabled"))
          end
          ),
          button_group(
            link_to_if_authorized(_("Delete"), hash_for_host_path(:id => @host).merge(:auth_object => @host, :permission => 'destroy_hosts'),
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
