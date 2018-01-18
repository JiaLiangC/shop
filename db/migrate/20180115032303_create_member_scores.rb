class CreateMemberScores < ActiveRecord::Migration[5.0]
  def change
    create_table :member_scores do |t|
      t.string :type
      t.integer :num
      t.integer :user_id
      t.string :description

      t.timestamps
    end
  end
end
