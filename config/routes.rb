Rails.application.routes.draw do
  match 'proxmox', to: 'foreman_proxmox/proxmoxserver#show'

end

ForemanProxmox::Engine.routes.draw do
    
    get 'proxmoxserver/start_all_vms' => 'proxmoxserver#start_all_vms', as: 'startall'
    get 'proxmoxserver/stop_all_vms' => 'proxmoxserver#stop_all_vms', as: 'stopall'
    get 'proxmoxserver/reboot' => 'proxmoxserver#reboot', as: 'reboot'
    get 'proxmoxserver/shutdown' => 'proxmoxserver#shutdown', as: 'shutdown'
    
    get 'proxmoxserver/start_all_vms' => 'proxmoxserver#start_all_vms', as: 'startall'
    get 'proxmoxserver/start_all_vms' => 'proxmoxserver#start_all_vms', as: 'startall'
    
    resource :proxmoxserver
         
    resources :virtualmachines, :only => [] do
        constraints(:id => /[^\/]+/) do
            get 'hosts/:id', :on => :collection, :to => 'virtualmachines#create_vm'
            get 'hosts/:id', :on => :collection, :to => 'virtualmachines#delete_vm'
        end
    end
end