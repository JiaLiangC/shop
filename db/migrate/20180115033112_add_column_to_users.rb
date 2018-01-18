class AddColumnToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :sex, :integer
  	add_column :users, :headimgurl, :string
  	add_column :users, :unionid, :string
  	add_index :users, :unionid
  end
end
