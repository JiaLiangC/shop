class AddScoreToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :score, :integer
  end
end
