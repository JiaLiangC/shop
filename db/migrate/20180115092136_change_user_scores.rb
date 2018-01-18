class ChangeUserScores < ActiveRecord::Migration[5.0]
  def change
  	change_table(:users) do |t|
  		t.remove :score
  		t.column :scores , :integer, null: false, default: 0
	end
  end

end
