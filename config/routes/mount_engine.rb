Foreman::Application.routes.draw do
  mount ForemanProxmox::Engine, :at => "/proxmox"
end