class AddUuidToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :uuid, :string, unique: true
    User.find_each do |u|
        u.uuid = RandomCode.generate_utoken
        u.save
    end
  end
end
