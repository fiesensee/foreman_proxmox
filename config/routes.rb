Rails.application.routes.draw do
  match 'proxmox', to: 'foreman_proxmox/proxmoxservers#show'

end

ForemanProxmox::Engine.routes.draw do
    
    get 'proxmoxserver/start_all_vms' => 'proxmoxservers#start_all_vms', as: 'startall'
    get 'proxmoxserver/stop_all_vms' => 'proxmoxservers#stop_all_vms', as: 'stopall'
    get 'proxmoxserver/reboot' => 'proxmoxservers#reboot', as: 'reboot'
    get 'proxmoxserver/shutdown' => 'proxmoxservers#shutdown', as: 'shutdown'
    
    get 'proxmoxserver/start_all_vms' => 'proxmoxservers#start_all_vms', as: 'startall'
    get 'proxmoxserver/start_all_vms' => 'proxmoxservers#start_all_vms', as: 'startall'
    
    resource :proxmoxserver
         
    resources :virtualmachines, :only => [] do
        constraints(:id => /[^\/]+/) do
            get 'hosts/:id', :on => :collection, :to => 'virtualmachines#create_vm'
            get 'hosts/:id', :on => :collection, :to => 'virtualmachines#delete_vm'
            get 'hosts/:id', :on => :collection, :to => 'virtualmachines#start'
            get 'hosts/:id', :on => :collection, :to => 'virtualmachines#stop'
            get 'hosts/:id', :on => :collection, :to => 'virtualmachines#reboot'
        end
    end
end