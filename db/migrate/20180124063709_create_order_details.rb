class CreateOrderDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :order_details do |t|
		t.integer  :order_id, null: false
	    t.string   :product_name, null: false
	    t.decimal   :product_price, null: false
	    # 商品型号，前台展示给客户
	    t.string   :product_cover_url
	    # 商品图片
	   	t.string   :product_marque
	   	#条形码
	   	t.string   :product_barcode
	   	# 记录商品型号，编号，规格颜色，包装等（65536）
	   	t.text 	   :product_params
	   	# 折扣比例
	   	t.decimal :discount_rate
	   	# 折扣金额
	   	t.decimal :discount_amount
	   	t.decimal :subtotal
	   	t.integer :number

      	t.timestamps
    end
  end
end
