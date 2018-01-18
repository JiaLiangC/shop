class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
        t.integer  :user_id
        t.string   :address_type
        t.string   :contact_name
        t.string   :mobile
        t.string   :address
        t.string   :zipcode
        t.timestamps
        t.index ["user_id", "address_type"], name: "index_addresses_on_user_id_and_address_type"
    end
  end
end
