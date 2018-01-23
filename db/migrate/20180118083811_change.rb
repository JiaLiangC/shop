class Change < ActiveRecord::Migration[5.0]
  def change
  	add_column :addresses, :order_id, :integer, default: nil
  	add_column :addresses, :type, :string, dfault: nil
  end
end
