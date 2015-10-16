class CreateForemanProxmoxVirtualMachines < ActiveRecord::Migration
  def change
    create_table :foreman_proxmox_virtual_machines do |t|
      t.string :vmid
      t.string :sockets
      t.string :cores
      t.string :memory
      t.string :size
      t.string :mac
      t.string :connection

      t.timestamps null: false
    end
  end
end
