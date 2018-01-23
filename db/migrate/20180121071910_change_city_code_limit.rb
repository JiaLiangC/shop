class ChangeCityCodeLimit < ActiveRecord::Migration[5.0]
  def change
  	change_column :cities, :area_code, :integer, limit: 8
  end
end
