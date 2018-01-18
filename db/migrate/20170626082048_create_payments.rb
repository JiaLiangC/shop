class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    create_table :payments do |t|
      t.integer :user_id
      t.string :payment_no
      t.string :transaction_no
      t.string :status, default: 'initial'
      t.decimal :total_money
      t.datetime :payment_at
      t.text :raw_response
      t.timestamps
    end

    add_index :payments, [:payment_no], unique: true
    add_index :payments, [:transaction_no]
    add_index :payments, [:user_id]
  end
end
