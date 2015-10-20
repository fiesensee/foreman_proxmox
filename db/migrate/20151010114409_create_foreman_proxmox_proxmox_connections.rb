class CreateForemanProxmoxProxmoxConnections < ActiveRecord::Migration
  def change
    create_table :foreman_proxmox_proxmox_connections do |t|
      t.string :ip
      t.string :username
      t.string :password

      t.timestamps null: false
    end
  end
end
