class AddIsActiveToProxmoxservers < ActiveRecord::Migration
  def change
    add_column :proxmoxservers, :IsActive, :boolean
  end
end
