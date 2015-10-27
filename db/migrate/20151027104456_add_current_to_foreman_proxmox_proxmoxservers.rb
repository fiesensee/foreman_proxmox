class AddCurrentToForemanProxmoxProxmoxservers < ActiveRecord::Migration
  def change
    add_column :foreman_proxmox_proxmoxservers, :current, :boolean
  end
end
