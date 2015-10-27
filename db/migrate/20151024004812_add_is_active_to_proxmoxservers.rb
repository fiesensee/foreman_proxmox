class AddIsActiveToForemanProxmoxProxmoxservers < ActiveRecord::Migration
  def change
    add_column :foreman_proxmox_proxmoxservers, :IsActive, :boolean
  end
end
