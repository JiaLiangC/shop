class CreateProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :profiles do |t|
        t.string   :avatar
        t.string   :location
        t.string   :gender
        t.string   :city
        t.text     :description
        t.integer  :age
        t.integer  :user_id
        t.date     :birthday
        t.timestamps
    end
  end
end
