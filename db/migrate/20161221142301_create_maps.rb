class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.string :title
      t.float :latitude
      t.float :longitude
      t.string :address
      t.string :body

      t.timestamps null: false
    end
  end
end
