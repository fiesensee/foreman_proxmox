module ForemanProxmox
  class Engine < ::Rails::Engine
    engine_name 'foreman_proxmox'
    isolate_namespace ForemanProxmox
    

    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/overrides"]
    
    initializer 'foreman_proxmox.mount_engine', :after=> :build_middleware_stack do |app|
      app.routes_reloader.paths << "#{ForemanProxmox::Engine.root}/config/routes/mount_engine.rb"
    end

    # Add any db migrations
    initializer 'foreman_proxmox.load_app_instance_data' do |app|
      app.config.paths['db/migrate'] += ForemanProxmox::Engine.paths['db/migrate'].existent
    end

    initializer 'foreman_proxmox.register_plugin', after: :finisher_hook do |_app|
      Foreman::Plugin.register :foreman_proxmox do
        requires_foreman '>= 1.4'

        # Add permissions
        security_block :foreman_proxmox do
          permission :view_foreman_proxmox, {:'foreman_proxmox/proxmoxservers' => [:index]}
          permission :manage_proxmoxserver, {:'foreman_proxmox/proxmoxservers' => [:new, :create, :stop_all_vms, :start_all_vms, :reboot_node, :shutdown_node]}
          permission :proxmoxservers_crud, {:'foreman_proxmox/proxmoxservers' => [:edit, :update, :show, :delete, :setcurrent]}
          permission :manage_vm, {:'foreman_proxmox/virtualmachines' => [:create_vm, :start_vm, :stop_vm, :reboot_vm, :delete_vm]}
        end

        # Add a new role called 'Discovery' if it doesn't exist
        role 'ForemanProxmox', [:view_foreman_proxmox, :manage_proxmoxserver, :proxmoxservers_crudm, :manage_vm]

        #add menu entry
        menu :top_menu, :template,
            url_hash: { controller: :'foreman_proxmox/proxmoxservers', action: :index },
            caption: 'ForemanProxmox',
            parent: :hosts_menu,
            after: :hosts

        # add dashboard widget
        # widget 'foreman_proxmox_widget', name: N_('Foreman plugin template widget'), sizex: 4, sizey: 1
      end
    end

    # Precompile any JS or CSS files under app/assets/
    # If requiring files from each other, list them explicitly here to avoid precompiling the same
    # content twice.
    assets_to_precompile =
      Dir.chdir(root) do
        Dir['app/assets/javascripts/**/*', 'app/assets/stylesheets/**/*'].map do |f|
          f.split(File::SEPARATOR, 4).last
        end
      end
    initializer 'foreman_proxmox.assets.precompile' do |app|
      app.config.assets.precompile += assets_to_precompile
    end
    initializer 'foreman_proxmox.configure_assets', group: :assets do
      SETTINGS[:foreman_proxmox] = { assets: { precompile: assets_to_precompile } }
    end

    # Include concerns in this config.to_prepare block
    config.to_prepare do
      begin
        Host::Managed.send(:include, ForemanProxmox::HostExtensions)
        HostsHelper.send(:include, ForemanProxmox::HostsHelperExtensions)
      rescue => e
        Rails.logger.warn "ForemanProxmox: skipping engine hook (#{e})"
      end
    end

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        ForemanProxmox::Engine.load_seed
      end
    end

    initializer 'foreman_proxmox.register_gettext', after: :load_config_initializers do |_app|
      locale_dir = File.join(File.expand_path('../../..', __FILE__), 'locale')
      locale_domain = 'foreman_proxmox'
      Foreman::Gettext::Support.add_text_domain locale_domain, locale_dir
    end
  end
end
