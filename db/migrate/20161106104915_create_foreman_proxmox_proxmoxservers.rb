class CreateForemanProxmoxProxmoxservers < ActiveRecord::Migration
  def change
    create_table :foreman_proxmox_proxmoxservers do |t|
      t.string :ip
      t.string :username
      t.string :password
      t.string :storage
      t.string :storagetype
      t.string :bridge
      t.boolean :current

      t.timestamps null: false
    end
  end
end
