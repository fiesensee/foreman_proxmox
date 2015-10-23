class AddMacToVirtualmachines < ActiveRecord::Migration
  def change
    add_column :foreman_proxmox_virtualmachines, :mac, :string
  end
end
