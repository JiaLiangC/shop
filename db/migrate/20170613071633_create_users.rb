class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
        t.string   :email
        t.string   :email_activation_digest
        t.boolean  :email_verified, default: false
        t.string   :password_digest, null: false
        t.datetime :activated_at 
        t.string   :remember_digest
        t.integer  :sign_in_count, null: false,default: 0
        t.datetime :current_sign_in_at
        t.datetime :last_sign_in_at
        t.string   :name
        t.string   :mobile
        t.boolean  :mobile_verified, default: false
        t.string   :reset_digest
        t.datetime :reset_sent_at
        t.string   :open_id
        t.timestamps
    end
    # add_index :users, [:email], unique: true
    add_index :users, [:mobile], unique: true
    # add_index :users, [:name], unique: true
  end
end
