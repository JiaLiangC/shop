class AddDefaultsToAddresses < ActiveRecord::Migration[5.0]
  def change
    add_column :addresses, :defaults, :boolean, default: false
  end
end
