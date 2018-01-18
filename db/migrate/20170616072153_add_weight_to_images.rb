class AddWeightToImages < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :weight, :integer,default: 0
    add_index :images, [:imgable_id]
    add_index :images,[:weight,:imgable_id]
  end
end
