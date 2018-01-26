class CreateLogistics < ActiveRecord::Migration[5.0]
  def change
    create_table :logistics do |t|

		t.integer :order_id
		# "订单编号 ( 订单表自动编号)"
		t.integer :address_id
		#订单地址 
		t.string :express_no
		# "物流单号 ( 发货快递单号)"
		t.string	:logistics_type
		# "物流方式（ ems, express）"
		t.decimal :delivery_amount
		 # "物流成本金额 (, 实际支付给物流公司的金额)"
		t.string :orderlogistics_status
		 # "物流状态 ()"
		t.string	:logistics_result_last
		 # "物流最后状态描述 ()"
		t.string	:logistics_result
		 # "物流描述 ()"
		t.string	:logistics_create_time
		 # "发货时间 ()"
		t.string	:logistics_update_time
		 # "物流更新时间 ()"
      	t.timestamps
    end
  end
end
