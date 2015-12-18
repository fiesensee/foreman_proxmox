class CreateForemanProxmoxVirtualmachines < ActiveRecord::Migration
  def change
    create_table :foreman_proxmox_virtualmachines, id: false do |t|
      t.primary_key :vmid
      t.string :name
      t.string :sockets
      t.string :cores
      t.string :memory
      t.string :size
      t.string :mac
      t.string :status
      t.string :errormsg
      t.belongs_to :host
      
      t.timestamps null: false
    end
  end
end
