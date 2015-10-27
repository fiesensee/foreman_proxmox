Rails.application.routes.draw do
  match 'proxmox', to: 'foreman_proxmox/proxmoxservers#index'

end

ForemanProxmox::Engine.routes.draw do
    
    get 'proxmoxservers/start_all_vms' => 'proxmoxservers#start_all_vms', as: 'startall'
    get 'proxmoxservers/stop_all_vms' => 'proxmoxservers#stop_all_vms', as: 'stopall'
    get 'proxmoxservers/reboot' => 'proxmoxservers#reboot', as: 'reboot'
    get 'proxmoxservers/shutdown' => 'proxmoxservers#shutdown', as: 'shutdown'
    
    get 'proxmoxservers/start_all_vms' => 'proxmoxservers#start_all_vms', as: 'startall'
    get 'proxmoxservers/start_all_vms' => 'proxmoxservers#start_all_vms', as: 'startall'
    
    resources :proxmoxservers
         
    resources :virtualmachines, :only => [] do
        constraints(:id => /[^\/]+/) do
            get 'create_vm/:id', :on => :collection, :to => 'virtualmachines#create_vm'
            get 'delete_vm/:id', :on => :collection, :to => 'virtualmachines#delete_vm'
            get 'start/:id', :on => :collection, :to => 'virtualmachines#start_vm'
            get 'stop/:id', :on => :collection, :to => 'virtualmachines#stop_vm'
            get 'reboot/:id', :on => :collection, :to => 'virtualmachines#reboot_vm'
        end
    end
end