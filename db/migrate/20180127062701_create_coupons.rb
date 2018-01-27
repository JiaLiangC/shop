class CreateCoupons < ActiveRecord::Migration[5.0]
  def change
    create_table :coupons do |t|
    t.integer :order_id
    	# 使用优惠券的订单
    t.string :uid
    	# 订单uuid
 		t.string :name
 		# 优惠券名称
 		
 		t.string :type
 		# 优惠券适用范围(单品，全场)

    t.string :limit
    # 使用条件（满减）
    
    t.string :channel
    # 渠道
 		t.text :description
 		# 优惠券规则描述
 		
 		t.string :status 
		# 优惠券状态

 		t.date :start_date
 		# 生效时间
 		t.date :end_date
 		# 介绍时间
 		t.decimal :property
 		# 面额

 		t.integer  :user_id
 		# 拥有者id
 		
 		t.integer :shop_id
 		# 店铺范围内的优惠券

 		
 		t.integer :category_id    
 		#店铺内某分类下的优惠券 

 		t.string :source_name
 		# 备用

 		t.integer :source_id
 		# 备用

 		t.decimal :minimum_cost
 		# 满减条件
     	t.timestamps
    end
  end
end
