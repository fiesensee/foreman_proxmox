Rails.application.routes.draw do

  mount ForemanProxmox::Engine => "/foreman_proxmox"
end
