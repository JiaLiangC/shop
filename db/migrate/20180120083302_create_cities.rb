class CreateCities < ActiveRecord::Migration[5.0]
  def change
    create_table :cities do |t|
      t.string :name
      t.integer :level
      t.integer :parent_id
      t.integer :area_code
      t.timestamps
    end
  end
end
