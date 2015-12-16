Rails.application.routes.draw do
  match 'proxmox', to: 'foreman_proxmox/proxmoxservers#index'

end

ForemanProxmox::Engine.routes.draw do
    
    get '/porxmox/proxmoxservers/:id/setcurrent' => 'proxmoxservers#setcurrent', as: 'setcurrent'
    get 'proxmoxservers/:id/destroy' => 'proxmoxservers#destroy', as: 'destroy'
    resources :proxmoxservers
         
    resources :virtualmachines, :only => [:show] do
        constraints(:id => /[^\/]+/) do
            get 'create_vm/:id', :on => :collection, :to => 'virtualmachines#create_vm'
            get 'delete_vm/:id', :on => :collection, :to => 'virtualmachines#delete_vm'
            get 'start/:id', :on => :collection, :to => 'virtualmachines#start_vm'
            get 'stop/:id', :on => :collection, :to => 'virtualmachines#stop_vm'
            get 'reboot/:id', :on => :collection, :to => 'virtualmachines#reboot_vm'
        end
    end
end