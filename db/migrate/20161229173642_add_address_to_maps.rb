class AddAddressToMaps < ActiveRecord::Migration
  def change
    change_column :maps, :address, :string
  end
end
