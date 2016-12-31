class ChangeDatatypeLatitudeAndLongitudeOfMaps < ActiveRecord::Migration
  def change
  	change_column :maps, :latitude, :double
  	change_column :maps, :longitude, :double
  	
  end
end
