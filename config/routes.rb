Rails.application.routes.draw do
  match 'proxmox', to: 'foreman_proxmox/proxmoxserver#show'

end

ForemanProxmox::Engine.routes.draw do
    
    
    resources :proxmoxserver, :only => [] do
        get '/start_all_vms', :to => 'proxmoxserver#start_all_vms'
    end
         
    resources :virtualmachines, :only => [] do
        constraints(:id => /[^\/]+/) do
            get 'hosts/:id', :on => :collection, :to => 'virtualmachines#create_vm'
            get 'hosts/:id', :on => :collection, :to => 'virtualmachines#delete_vm'
        end
    end
end