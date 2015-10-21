Rails.application.routes.draw do
  match 'proxmox', to: 'foreman_proxmox/proxmoxservers#index'

end

ForemanProxmox::Engine.routes.draw do
    
    
    resources :proxmoxserver
         
    resources :virtualmachines, :only => [] do
        constraints(:id => /[^\/]+/) do
            get 'hosts/:id', :on => :collection, :to => 'virtualmachines#create_vm'
            get 'hosts/:id', :on => :collection, :to => 'virtualmachines#delete_vm'
        end
    end
end