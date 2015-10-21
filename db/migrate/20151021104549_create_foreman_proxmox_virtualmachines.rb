class CreateForemanProxmoxVirtualMachines < ActiveRecord::Migration
  def change
    create_table :foreman_proxmox_virtualmachines do |t|
      t.string :vmid
      t.string :sockets
      t.string :cores
      t.string :memory
      t.string :size
      t.belongs_to :proxmoxserver
      
      t.timestamps null: false
    end
  end
end
