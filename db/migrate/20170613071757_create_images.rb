class CreateImages < ActiveRecord::Migration[5.0]
  def change
    create_table :images do |t|
        t.integer  :imgable_id
        t.string   :imgable_type
        t.string   :name
        t.integer  :user_id
        t.string   :filename
        t.string   :storage
        t.timestamps
    end
    add_index :images, [:name]
  end
end
