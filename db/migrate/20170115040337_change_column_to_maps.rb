class ChangeColumnToMaps < ActiveRecord::Migration
  def change
  	change_column :maps, :latitude, :decimal,precision: 11,scale: 8
  	change_column :maps, :longitude, :decimal,precision: 11,scale: 8
  end
end
