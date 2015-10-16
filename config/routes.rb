Rails.application.routes.draw do
  match 'proxmox', to: 'foreman_proxmox/connection#index'

end

ForemanProxmox::Engine.routes.draw do
    
    resources :connection
     
    resources :vm, :only => [] do
        constraints(:id => /[^\/]+/) do
            get 'hosts/:id', :on => :collection, :to => 'vm#create_vm'
        end
    end
end
