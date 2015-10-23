class AddMacToVirtualmachines < ActiveRecord::Migration
  def change
    add_column :virtualmachines, :mac, :string
  end
end
