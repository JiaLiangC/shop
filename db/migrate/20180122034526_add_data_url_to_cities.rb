class AddDataUrlToCities < ActiveRecord::Migration[5.0]
  def change
    add_column :cities, :data_url, :string
    add_column :cities, :count, :integer,default: 0
  end
end
