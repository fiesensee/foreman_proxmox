class AddIsCurrentToForemanProxmoxProxmoxservers < ActiveRecord::Migration
  def change
    add_column :foreman_proxmox_proxmoxservers, :IsCurrent, :boolean
  end
end
